local Trie = {}

function Trie.new()
	local self = {}
	self.children = {}
	self.size = 0
	
	function self.get_strings(s)
		local words = {}
		local function find(root, str)
			local word = table.concat(str)
			if root.size == 0 then
				table.insert(words, word)
				return
			end
			for node_name, node in pairs(root.children) do
				if word..node_name ~= s and #word + 1 == #s then
					continue
				end
				table.insert(str, node_name)
				find(node, str)
				table.remove(str)
			end
		end
		find(self,{})
		return words
	end
	
	function self.delete(s)
		local function del(root, i)
			if i == #s+1 then
				return root.size == 0
			end
			local char = s:sub(i,i)
			local next_del = del(root.children[char],i+1)
			if next_del then
				root.children[char] = nil
				root.size = root.size - 1
			end
			return root.size == 0
		end
		if self.search(s) then
			del(self,1)
		end
	end
	
	function self.search(s)
		local node = self
		for i = 1, #s do
			local char = s:sub(i,i)
			if not node.children[char] then
				return false
			end
			node = node.children[char]
		end
		return true
	end
	
	function self.insert(s)
		local r = self
		for i = 1, #s do
			local char = s:sub(i,i)
			if not r.children[char] then
				r.size = r.size + 1
				r.children[char] = Trie.new()
			end
			r = r.children[char]
		end
	end
	
	return self
end

return Trie
