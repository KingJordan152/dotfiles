return {
	settings = {
		yaml = {
			schemaStore = {
				-- Built-in schemaStore support must be disabled if `SchemaStore` plugin is to be used.
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
