vim.opt_local.commentstring = "// %s"

-- Check if file is an opentofu file.
local function is_opentofu()
  -- Filepaths that indicate an Opentofu filetype.
  local opentofuPaths = {
    "./tofu/.*%.tf",
    "./tofu/.*%.tfvars",
  }

  -- Check filepaths.
  local filepath = vim.fn.expand("%:p")
  for _, path in pairs(opentofuPaths) do
    if string.match(filepath, path) then
      return true
    end
  end

  return false
end

if is_opentofu() then
  vim.bo.filetype = "opentofu"
end
