-- test_example.lua
local utesting = require("utesting")

describe("Example Tests", function()
    it("should pass", function()
        utesting.assert_true(true, "Expected true to be true")
    end)

    it("should fail", function()
        utesting.assert_false(false, "Expected false to be true") -- This will fail
    end)
end)
luarocks install busted
busted test_example.lua
