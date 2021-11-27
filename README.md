# Luver GitHub Action

:first_quarter_moon_with_face: Set up your GitHub Actions workflow with specific versions of Lua, LuaJIT, LuaRocks using _**[Luver](https://github.com/MunifTanjim/luver)**_ :heart:

## Usage

See [action.yml](./action.yml)

**Basic:**

```yml
steps:
  - uses: actions/checkout@v2
  - uses: MunifTanjim/luver-action@v1
  - run: |
      luver install lua 5.4.3
      luver use 5.4.3
      luver install luarocks 3.8.0
  - run: |
      luarocks install luacheck
```

**Pre-install versions:**

```yml
steps:
  - uses: actions/checkout@v2
  - uses: MunifTanjim/luver-action@v1
    with:
      lua_versions: 5.1.5 5.4.3
      luajit_versions: 5.1.5:2.1.0-beta3
      luarocks_versions: 5.1.5:3.7.0 5.4.3:3.8.0
  - run: |
      luver use 5.1.5
      lua -v
      luajit -v
      luarocks --version
```

## License

Licensed under the MIT License. Check the [LICENSE](./LICENSE) file for details.
