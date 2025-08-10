#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Wayland Idle Inhibitor - A systray app to toggle screen sleep.
#
# Author: Gemini
# Date: 2025-06-12
#
# This script uses modern desktop protocols to work on Wayland:
# - org.freedesktop.portal.Inhibit: To prevent the screen from sleeping.
# - org.kde.StatusNotifierItem: To create a clickable tray icon.
#
# It is designed for minimal setups (like a patched dwl) and does not
# require a full GUI toolkit like GTK or Qt.

import sys
import os
from gi.repository import GLib
import pydbus

# --- Configuration ---
# You can change these icon names to match what's available in your icon theme.
# I'm using symbolic icons as they adapt to light/dark themes.
ICON_INHIBIT_OFF = 'user-available-symbolic' # Icon when inhibitor is OFF (e.g., a checkmark, available status)
ICON_INHIBIT_ON = 'user-busy-symbolic'       # Icon when inhibitor is ON (e.g., a coffee cup, busy status)
APP_ID = 'dev.gemini.IdleInhibitor'
APP_PATH = '/dev/gemini/IdleInhibitor'

class IdleInhibitorTray:
    """
    This class handles both the idle inhibition logic via the freedesktop portal
    and the system tray icon via the StatusNotifierItem D-Bus interface.
    """

    # D-Bus interface definition for the StatusNotifierItem (systray icon).
    # This XML tells D-Bus what properties and methods our application provides.
    dbus_xml = """
    <node>
        <interface name='org.kde.StatusNotifierItem'>
            <property name='Category' type='s' access='read'/>
            <property name='Id' type='s' access='read'/>
            <property name='Title' type='s' access='read'/>
            <property name='Status' type='s' access='read'/>
            <property name='IconName' type='s' access='read'/>
            <property name='ToolTip' type='s' access='read'/>
            <method name='Activate'>
                <arg type='i' name='x' direction='in'/>
                <arg type='i' name='y' direction='in'/>
            </method>
        </interface>
    </node>
    """

    def __init__(self, bus):
        # --- State Variables ---
        self.inhibited = False  # Is the screen currently inhibited?
        self.inhibit_request_path = None # Stores the D-Bus object path for the active inhibit request.
        self.portal = None
        self.bus = bus

        # --- Initial Tray Icon Setup ---
        self.IconName = ICON_INHIBIT_OFF
        self.Title = "Idle Inhibitor"
        self.Id = "idle-inhibitor"
        self.Category = "ApplicationStatus"
        self.Status = "Active" # Can be 'Active', 'Passive', or 'NeedsAttention'

        # Connect to the freedesktop portal for inhibiting
        try:
            self.portal = self.bus.get('org.freedesktop.portal.Desktop', '/org/freedesktop/portal/Desktop')
        except GLib.Error as e:
            print(f"Error: Could not connect to the freedesktop portal.", file=sys.stderr)
            print(f"Please ensure 'xdg-desktop-portal' is running.", file=sys.stderr)
            print(f"Details: {e}", file=sys.stderr)
            sys.exit(1)
        
        self.update_tooltip()

    def update_tooltip(self):
        """Updates the tooltip text based on the current state."""
        state_text = "ON" if self.inhibited else "OFF"
        self.ToolTip = f"Idle Inhibitor is {state_text}\nClick to toggle."

    def Activate(self, x, y):
        """
        This method is called via D-Bus when the user clicks the tray icon.
        It toggles the inhibition state.
        """
        if self.inhibited:
            self.stop_inhibiting()
        else:
            self.start_inhibiting()

        # Update state and icon
        self.inhibited = not self.inhibited
        self.IconName = ICON_INHIBIT_ON if self.inhibited else ICON_INHIBIT_OFF
        self.update_tooltip()
        
        # This is a bit of a trick with pydbus to notify the status bar
        # that our properties have changed, so it should redraw the icon/tooltip.
        # We re-publish the object which triggers a properties changed signal.
        self.bus.publish(APP_ID, self)
        print(f"Idle inhibitor toggled. State is now: {'ON' if self.inhibited else 'OFF'}")

    def start_inhibiting(self):
        """Calls the portal to prevent the screen from sleeping."""
        print("Requesting idle inhibition...")
        try:
            # We need a unique handle for the request. An empty string works.
            # The reason is a human-readable string for why we are inhibiting.
            self.inhibit_request_path = self.portal.Inhibit(
                '',  # A window identifier, can be empty for this purpose
                {'handle_token': 'gemini_idle_inhibitor'}, # Options
                "User toggled idle inhibitor application" # Reason
            )
            print(f"Successfully started inhibiting. Request path: {self.inhibit_request_path}")
        except GLib.Error as e:
            print(f"Error: Failed to start inhibiting: {e}", file=sys.stderr)
            self.inhibited = False # Ensure state is correct on failure


    def stop_inhibiting(self):
        """Closes the inhibition request to allow the screen to sleep again."""
        if not self.inhibit_request_path:
            return

        print(f"Stopping idle inhibition for request: {self.inhibit_request_path}")
        try:
            # To stop inhibiting, we get a proxy for the request object itself
            # and call its 'Close' method.
            request_object = self.bus.get('org.freedesktop.portal.Desktop', self.inhibit_request_path)
            request_object.Close()
            self.inhibit_request_path = None
            print("Successfully stopped inhibiting.")
        except GLib.Error as e:
            print(f"Error: Failed to stop inhibiting: {e}", file=sys.stderr)
            # It might have been closed already, so we clear the path anyway.
            self.inhibit_request_path = None


if __name__ == '__main__':
    print("Starting Wayland Idle Inhibitor...")
    # The main event loop that listens for D-Bus events (like clicks).
    loop = GLib.MainLoop()

    # We need to connect to the D-Bus session bus.
    bus = pydbus.SessionBus()

    try:
        # Create an instance of our inhibitor application.
        app = IdleInhibitorTray(bus)
        
        # Publish our application on D-Bus so the status bar can find it.
        # We give it a unique name (APP_ID) and object path (APP_PATH).
        bus.publish(APP_ID, (APP_PATH, app))
        
        # Register our new tray icon with the StatusNotifierWatcher.
        print("Registering item with StatusNotifierWatcher...")
        
        # The dwl patch for the systray is minimal and may not support D-Bus introspection.
        # Instead of creating a proxy object with bus.get(), we make a direct method call,
        # which is more robust against services that don't provide introspection data.
        bus.call(
            'org.kde.StatusNotifierWatcher',         # D-Bus service name
            '/StatusNotifierWatcher',                # Object path on the service
            'org.kde.StatusNotifierWatcher',         # Interface to call the method on
            'RegisterStatusNotifierItem',            # Method name
            (APP_ID,)                                # Parameters (as a tuple)
        )
        print("Item registered successfully.")

    except GLib.Error as e:
        print(f"A critical D-Bus error occurred on startup: {e}", file=sys.stderr)
        print("\nIs a StatusNotifierWatcher (like waybar or a patched dwl) running?", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"A critical error occurred on startup: {e}", file=sys.stderr)
        sys.exit(1)

    print("Idle inhibitor is running. Click the tray icon to toggle. Press Ctrl+C to exit.")
    
    try:
        # This will run forever until the script is terminated.
        loop.run()
    except KeyboardInterrupt:
        print("\nExiting...")
        # Cleanly stop inhibiting if the app is closed while active.
        if app.inhibited:
            app.stop_inhibiting()
    finally:
        loop.quit()

