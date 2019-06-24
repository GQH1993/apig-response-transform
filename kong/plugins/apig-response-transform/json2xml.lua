

local M = {}

local indentation = "" --����
local xml = ""
local str = ""


---firstToUpper ���ַ�������ĸ��д
---@param str  ��Ҫ��д���ַ���
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

---isArrayTable
---@param t table �ж��Ƿ�Ϊ�������͵�table
---@return boolean �������ͷ���true�����򷵻�false
function M.isArrayTable(t)
    if type(t) ~= "table" then
        return false
    end

    local n = #t
    for i,v in pairs(t) do
        if type(i) ~= "number" then
            return false
        end

        if i > n then
            return false
        end
    end

    return true
end



---toxml ��json��ʽ����ת��
---@param table table ����Ӧbodyת��������table����
---@return string ����xml��ʽ����
function M.toxml(tblBody)
    ProcessResponseBody(tblBody)
    local result = xml
    xml=""
    return result
end

---ProcessResponseBody ����ת��������ͨ���ݹ齫jsonת��Ϊxml
---@param value table ��Ҫת����table��ʽ������
---@return nil ��̬����xml�ַ���
function ProcessResponseBody(value)
    if type(value) == "string" then
        str = str .. indentation ..firstToUpper(value) .. "\n"
        xml = xml .. str
        str = " "
    elseif type(value) == "table" then
        for name,data in pairs(value) do
            --���keyΪ�ַ�����Ҳ����˵��json����
            if type(name) == "string" then
                if type(data) == "string" then
                    str = str .. indentation .."<" .. firstToUpper(name) .. ">" .. data .. "</" .. firstToUpper(name) .. ">\n"
                    xml = xml .. str
                    str = ""

                elseif type(data) == "number" or type(data) == "boolean" then
                    str =  str .. indentation .. "<" ..firstToUpper(name) .. ">" .. tostring(data) .. "</" .. firstToUpper(name) .. ">\n"
                    xml = xml .. str
                    str = ""
                elseif type(data) == "table" then
                    --������������͵�table�������table����ÿ��Ԫ����ӱ�ǩ
                    if M.isArrayTable(data) then
                        for tblName,tblData in pairs(data) do
                            xml = xml .. indentation .. "<" .. firstToUpper(name) .. ">\n"
                            indentation = indentation .. "\t"
                            ProcessResponseBody(tblData)
                            indentation = indentation:sub(1,#indentation-1)
                            str = str .. indentation .."</" .. firstToUpper(name) .. ">\n"
                            xml = xml .. str
                            str = " "
                        end
                    --�����json���󣬼ӱ�ǩ������ݽ��б���
                    else
                        xml = xml .. indentation .. "<" .. firstToUpper(name) .. ">\n"
                        indentation = indentation .. "\t"
                        ProcessResponseBody(data)
                        indentation = indentation:sub(1,#indentation-1)
                        str = str .. indentation .."</" .. firstToUpper(name) .. ">\n"
                        xml = xml .. str
                        str = " "
                    end
                end
            end
        end
    end
end

return M

