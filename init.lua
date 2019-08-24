utfparse = {}

local function codepoint_to_utf8(codep)
    if codep < 128 then
        return string.char(codep)
    end
    local s = ""
    local max_pf = 32
    while true do
        local suffix = codep % 64
        s = string.char(128 + suffix)..s
        codep = (codep - suffix) / 64
        if codep < max_pf then
            return string.char((256 - (2 * max_pf)) + codep)..s
        end
        max_pf = max_pf / 2
    end
end


function utfparse.parse(text)
  local retval = ""
  local sindex,eindex = string.find(text, "&#(x?)([0123456789abcdef]+);")
  while sindex~=nil do
    retval=retval..text:sub(1,sindex-1)
    unicharac = text:sub(sindex,eindex)
    text = text:sub(eindex+1, #text)
    local hexa, codepointstr = string.match(unicharac, "&#(x?)([0123456789abcdef]+);")
    if hexa == 'x' then
      codepoint = tonumber(codepointstr, 16)
    else
      codepoint = tonumber(codepointstr)
    end
    retval = retval..codepoint_to_utf8(codepoint)
    print(hexa, codepointstr, sindex, eindex, codepoint, codepoint_to_utf8(codepoint), text)
    sindex,eindex = string.find(text, "&#(x?)([0123456789abcdef]+);")
  end
  return retval..text
end

print(utfparse.parse(" Et l&#xe0;, &#xe7;&#xe1; &#x65e5;&#x672c;&#x8a9e;?"))
