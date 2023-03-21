local ts_utils = require "nvim-treesitter.ts_utils"
local ps = require "plenary.strings"

local M = {}

local function merge_table(table1, table2)
	for _, value in ipairs(table2) do
		table1[#table1+1] = value
	end
	return table1
end

local function get_function_node()
  local node = ts_utils.get_node_at_cursor()

  if node == nil then
    error("No Treesitter parser found")
  end

  if node:type() == "function_definition" or node:type() == "method_declaration" then
    return node
  else
    local root = ts_utils.get_root_for_node(node)
    local parent = node:parent()

    while (parent ~= nil and parent ~= root) do
      node = parent
      parent = node:parent()

      if node:type() == "function_definition" or node:type() == "method_declaration" then
        break
      end
    end
  end

  return node
end

function M.insert_php_doc()
  local bufnr = vim.api.nvim_get_current_buf()
  local node = get_function_node()
  if node:type() ~= "function_definition" and node:type() ~= "method_declaration" then
    print("Not in function node")
    return
  end

  -- Get function parameters
  local params = {}
  local parametersNode = node:field("parameters")[1]
  for simple_parameter, _ in parametersNode:iter_children() do
    if simple_parameter:type() == "simple_parameter" then
      local paramTypeNode = simple_parameter:field("type")[1]
      local paramNameNode = simple_parameter:field("name")[1]
      local paramDefaultValueNode = simple_parameter:field("default_value")[1]

      local type = 'type'
      local name = ''
      local default_value = ''

      if paramTypeNode ~= nil then
        type = vim.treesitter.get_node_text(paramTypeNode, bufnr)
      end

      if paramNameNode ~= nil then
        name = vim.treesitter.get_node_text(paramNameNode, bufnr)
      end

      if paramDefaultValueNode ~= nil then
        default_value = ' (optional)'
      end

      table.insert(params, " * @param " .. type .. " " .. name .. default_value)
    end
  end

  local returnTypeNode = node:field("return_type")[1]
  local returnLine = " * @return"

  if returnTypeNode ~= nil then
    returnLine = returnLine .. " " .. vim.treesitter.get_node_text(returnTypeNode, bufnr)
  end

  local linesStart = { "/**", " * description", " *" }
  local linesEnd = { returnLine, " */" }

  local lines = merge_table(linesStart, params)
  lines = merge_table(lines, linesEnd)


  local row1, col1, row2, col2 = node:range()

  for i, v in ipairs(lines) do
    local shiftedLine = ps.dedent(v, col1)
		lines[i] = shiftedLine
  end
  vim.api.nvim_buf_set_lines(bufnr, row1, row1, 0, lines)
end

return M
