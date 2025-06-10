#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAX_FILENAME_LENGTH 256
#define SCREENSHOT_DIR_FORMAT "%s/Pictures/Screenshots"
#define FILENAME_FORMAT "screenshot_%Y%m%d_%H%M%S.png"
#define GRIM_COMMAND_FORMAT "grim -g \"%s\" \"%s\""
#define WL_COPY_COMMAND_FORMAT "grim -g \"%s\" - | wl-copy --type image/png"
#define NOTIFY_SEND_COMMAND_FORMAT "notify-send \"Skrinsutto di seve di %s/%s\""
#define SLURP_COMMAND "slurp"

int main() {
    char screenshot_dir[MAX_FILENAME_LENGTH];
    char filename[MAX_FILENAME_LENGTH];
    char filepath[MAX_FILENAME_LENGTH * 2];
    char timestamp_str[64];
    time_t timer;
    struct tm* tm_info;
    char *area = NULL;
    size_t area_len = 0;
    ssize_t area_read;
    char grim_command[MAX_FILENAME_LENGTH * 3];
    char wl_copy_command[MAX_FILENAME_LENGTH * 3];
    char notify_send_command[MAX_FILENAME_LENGTH * 2];

    // Get the HOME directory
    const char *home_dir = getenv("HOME");
    if (home_dir == NULL) {
        fprintf(stderr, "Error: HOME environment variable not set.\n");
        return 1;
    }

    // Define the screenshot directory
    snprintf(screenshot_dir, sizeof(screenshot_dir), SCREENSHOT_DIR_FORMAT, home_dir);

    // Ensure the directory exists
    struct stat st;
    if (stat(screenshot_dir, &st) == -1) {
        if (mkdir(screenshot_dir, 0755) != 0) {
            perror("Error creating screenshot directory");
            return 1;
        }
    }

    // Generate a timestamp for the filename
    time(&timer);
    tm_info = localtime(&timer);
    strftime(timestamp_str, sizeof(timestamp_str), FILENAME_FORMAT, tm_info);

    // Define the filename and filepath
    snprintf(filename, sizeof(filename), "%s", timestamp_str);
    snprintf(filepath, sizeof(filepath), "%s/%s", screenshot_dir, filename);

    // Execute slurp to get the selected area
    FILE *slurp_proc = popen(SLURP_COMMAND, "r");
    if (slurp_proc == NULL) {
        perror("Error executing slurp");
        return 1;
    }

    area_read = getline(&area, &area_len, slurp_proc);
    pclose(slurp_proc);

    // Remove trailing newline from area
    if (area_read > 0 && area[area_read - 1] == '\n') {
        area[area_read - 1] = '\0';
    }

    if (area != NULL && strlen(area) > 0) {
        // Define and execute the grim command
        snprintf(grim_command, sizeof(grim_command), GRIM_COMMAND_FORMAT, area, filepath);
        if (system(grim_command) != 0) {
            perror("Error executing grim");
            free(area);
            return 1;
        }

        // Define and execute the grim and wl-copy command
        snprintf(wl_copy_command, sizeof(wl_copy_command), WL_COPY_COMMAND_FORMAT, area);
        if (system(wl_copy_command) != 0) {
            perror("Error copying to clipboard");
        }

        // Define and execute the notify-send command
        snprintf(notify_send_command, sizeof(notify_send_command), NOTIFY_SEND_COMMAND_FORMAT, screenshot_dir, filename);
        if (system(notify_send_command) != 0) {
            perror("Error sending notification");
        }
    }

    free(area);
    return 0;
}
