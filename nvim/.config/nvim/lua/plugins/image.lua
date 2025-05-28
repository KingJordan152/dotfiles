return {
	"3rd/image.nvim",
	build = false,
	opts = {
		-- processor = "magick_cli",
		-- backend = "kitty",
		integrations = {
			markdown = {
				resolve_image_path = function(document_path, image_path, fallback)
					-- Define the absolute path to your Assets directory
					local assets_dir = vim.fn.expand("~/Documents/Obsidian Vault/Misc./Attachments") -- not the path to vault, but to the assets dir

					-- Check if the image_path is already an absolute path
					if image_path:match("^/") then
						-- If it's an absolute path, leave it unchanged
						return image_path
					end

					-- Construct the new image path by prepending the Assets directory
					local new_image_path = assets_dir .. "/" .. image_path

					-- Check if the constructed path exists
					if vim.fn.filereadable(new_image_path) == 1 then
						return new_image_path
					else
						-- If the file doesn't exist in Assets, fallback to default behavior
						return fallback(document_path, image_path)
					end
				end,
			},
		},
	},
}
