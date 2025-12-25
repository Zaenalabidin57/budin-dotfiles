set -gx BW_SESSION "ek37z6ejsm2xftSo3NLiQNrbi/9LR1wv9HWcDOSC2TnU/XMYF+2PPBrWfU+McivIk753883RGDKaEnt6P1lzpQ=="
set -gx ANTHROPIC_BASE_URL "https://agentrouter.org/"
#set -gx ANTHROPIC_AUTH_TOKEN "sk-00qp5Um4wtthF6Z0IU4NdUmXShWr22aKtsRRCn4G7FswOoOj"
set -gx ANTHROPIC_API_KEY "sk-00qp5Um4wtthF6Z0IU4NdUmXShWr22aKtsRRCn4G7FswOoOj"

set -gx OPENAI_BASE_URL "https://agentrouter.org/v1"
set -gx OPENAI_AUTH_TOKEN "sk-00qp5Um4wtthF6Z0IU4NdUmXShWr22aKtsRRCn4G7FswOoOj"
set -gx OPENAI_API_KEY "sk-00qp5Um4wtthF6Z0IU4NdUmXShWr22aKtsRRCn4G7FswOoOj"
set -gx AVANTE_OPENAI_API_KEY "sk-00qp5Um4wtthF6Z0IU4NdUmXShWr22aKtsRRCn4G7FswOoOj"
set -gx AGENTROUTER_API_KEY "sk-00qp5Um4wtthF6Z0IU4NdUmXShWr22aKtsRRCn4G7FswOoOj"
set -gx AGENT_ROUTER_TOKEN "sk-00qp5Um4wtthF6Z0IU4NdUmXShWr22aKtsRRCn4G7FswOoOj"
set -gx OPENAI_MODEL "glm-4.5"
#set -gx OPENAI_MODEL "claude-sonnet-4-5-20250929"
#set -gx OPENAI_MODEL "claude-sonnet-4-5-20250929"
#set -gx OPENAI_MODEL "deepseek-r1-0528"

function qwen
  /usr/bin/env qwen  --openai-api-key $OPENAI_AUTH_TOKEN --openai-base-url $OPENAI_BASE_URL $argv --model $OPENAI_MODEL
end

function qwendeep
  /usr/bin/env qwen  --openai-api-key $OPENAI_AUTH_TOKEN --openai-base-url $OPENAI_BASE_URL $argv --model deepseek-v3.2
end

function qwenr1
  /usr/bin/env qwen  --openai-api-key $OPENAI_AUTH_TOKEN --openai-base-url $OPENAI_BASE_URL $argv --model deepseek-r1-0528
end

function qwenai
  /usr/bin/env qwen  --openai-api-key $OPENAI_AUTH_TOKEN --openai-base-url $OPENAI_BASE_URL $argv --model gpt-5.2
end

function qwenclod
  /usr/bin/env qwen  --openai-api-key $OPENAI_AUTH_TOKEN --openai-base-url $OPENAI_BASE_URL $argv --model claude-haiku-4-5-20251001
end

function qwengemini
  /usr/bin/env qwen  --openai-api-key $OPENAI_AUTH_TOKEN --openai-base-url $OPENAI_BASE_URL $argv --model gemini-3-pro-preview
end
function qwenkimi
  /usr/bin/env qwen  --openai-api-key $OPENAI_AUTH_TOKEN --openai-base-url $OPENAI_BASE_URL $argv --model kimi-k2-thinking
end

