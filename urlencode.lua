local string = require "string"
local table = require "table"

--Module table
local urlencode={}

--URL encode a string.
local function encode(str)

  --Ensure all newlines are in CRLF form
  str = string.gsub (str, "\r?\n", "\r\n")

  --Percent-encode all non-unreserved characters
  --as per RFC 3986, Section 2.3
  --(except for space, which gets plus-encoded)
  str = string.gsub (str, "([^%w%-%.%_%~ ])",
    function (c) return string.format ("%%%02X", string.byte(c)) end)

  --Convert spaces to plus signs
  str = string.gsub (str, " ", "+")

  return str
end

--Make this function available as part of the module
urlencode.string = encode

--URL encode a table as a series of parameters.
function urlencode.table(t)

  --table of argument strings
  local argts = {}

  --insertion iterator
  local i = 1

  --URL-encode every pair
  for k, v in pairs(t) do
    argts[i]=encode(k).."="..encode(v)
    i=i+1
  end

  return table.concat(argts,'&')
end

return urlencode
