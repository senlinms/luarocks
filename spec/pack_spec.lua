local test_env = require("test/test_environment")
local lfs = require("lfs")
local run = test_env.run
local testing_paths = test_env.testing_paths

test_env.unload_luarocks()

local extra_rocks = {
	"/luasec-0.6-1.rockspec",
	"/luasocket-3.0rc1-1.src.rock",
	"/luasocket-3.0rc1-1.rockspec",
   "/say-1.2-1.src.rock",
   "/say-1.0-1.src.rock"
}

describe("LuaRocks pack tests #blackbox #b_pack", function()

   before_each(function()
      test_env.setup_specs(extra_rocks)
   end)

   it("LuaRocks pack with no flags/arguments", function()
      assert.is_false(run.luarocks_bool("pack"))
   end)

   it("LuaRocks pack basic", function()
      assert.is_true(run.luarocks_bool(test_env.quiet("pack luacov")))
      assert.is_true(test_env.remove_files(lfs.currentdir(), "luacov-"))
   end)

   it("LuaRocks pack invalid rockspec", function()
      assert.is_false(run.luarocks_bool("pack " .. testing_paths.testing_dir .. "/testfiles/invaild_validate-args-1.5.4-1.rockspec"))
   end)

   it("LuaRocks pack not installed rock", function()
      assert.is_false(run.luarocks_bool("pack cjson"))
   end)
   
   it("LuaRocks pack not installed rock from non existing manifest", function()
      assert.is_false(run.luarocks_bool("pack /non/exist/temp.manif"))
   end)

   it("LuaRocks pack specify which version of rock", function()
      assert.is_true(run.luarocks_bool("install say 1.2"))
      assert.is_true(run.luarocks_bool("install luassert"))
      assert.is_true(run.luarocks_bool("install say 1.0"))
      
      assert.is_false(run.luarocks_bool("pack say"))
   end)

   it("LuaRocks pack src", function()
      assert.is_true(run.luarocks_bool(test_env.quiet("install luasec")))
      assert.is_true(run.luarocks_bool("download --rockspec luasocket 3.0rc1-1"))
      assert.is_true(run.luarocks_bool("pack luasocket-3.0rc1-1.rockspec"))
      assert.is_true(test_env.remove_files(lfs.currentdir(), "luasocket-"))
   end)
end)


