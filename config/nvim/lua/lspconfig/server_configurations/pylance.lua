local util = require("lspconfig.util")

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
}

local function exepath(expr)
    local ep = vim.fn.exepath(expr)
    return ep ~= "" and ep or nil
end

return {
    default_config = {
        before_init = function(_, config)
            if not config.settings.python then
                config.settings.python = {}
            end
            if not config.settings.python.pythonPath then
                config.settings.python.pythonPath = exepath("python3") or exepath("python") or "python"
            end
        end,
        cmd = {
            "node",
            "--max-old-space-size=8192",
            vim.fn.expand("~/.vscode-server/extensions/ms-python.vscode-pylance-2024.6.1/dist/server_nvim.js", false,
                true)[1],
            "--stdio",
        },
        filetypes = { "python" },
        single_file_support = true,
        root_dir = util.root_pattern(unpack(root_files)),
        settings = {
            python = {
                editor = {
                    formatOnSave = false,
                },
                analysis = {
                    include = {
                        "deployable/amplify/*",
                        "affiliate/*",
                        "agents/*",
                        "amplify/*",
                        "anywhere2/*",
                        "applications2/*",
                        "ari-service/*",
                        "auth2/*",
                        "axp/*",
                        "bank/*",
                        "benefits/*",
                        "billing/*",
                        "caching/*",
                        "card_processor/*",
                        "challenge/*",
                        "checkout_flow_interface/*",
                        "chrono/*",
                        "copy_registry_lib/*",
                        "crypto4/*",
                        "counters2/*",
                        "counters2/*",
                        "chameleon/*",
                        "chameleon/*",
                        "disclosures2/*",
                        "dispute_temp/*",
                        "deposits/*",
                        "disclosures2/*",
                        "external_service_proxy/*",
                        "etl_lib/*",
                        "event_bus2/*",
                        "file_storage/*",
                        "financial_instruments/*",
                        "financial_products/*",
                        "fraud/*",
                        "guarantee_flow_interface/*",
                        "httplibs/*",
                        "identity/*",
                        "idol/*",
                        "infra/*",
                        "javelin/*",
                        "l10n_format_lib/*",
                        "loan_attribution/*",
                        "mdt/*",
                        "members/*",
                        "merchants3/*",
                        "messages2/*",
                        "ml2/*",
                        "models/*",
                        "permissions/*",
                        "platform/*",
                        "product_flows/*",
                        "qualifications/*",
                        "rewards2/*",
                        "rewards_rpc/*",
                        "rpc2/*",
                        "servicing/*",
                        "sql-store/*",
                        "taa/*",
                        "tank/*",
                        "tns_shared/*",
                        "toolbox/*",
                        "toolbox2/*",
                        "traintrack/*",
                        "treasury2/*",
                        "tulip/*",
                        "underwriting/*",
                        "usercomms_temp/*",
                        "usercomms/*",
                        "users2/*",
                    },
                    inlayHints = {
                        variableTypes = false,
                        functionReturnTypes = false,
                        callArgumentNames = false,
                        pytestParameters = false,
                    },
                },
            },
        },
    },
}
