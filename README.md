# Homebrew Tools (Tap)

This repository contains Homebrew formulae for the tools needed.

## Tools

- **`dineroIV`**: Cache simulator by Mark D. Hill. [**Source code repository**](https://github.com/atos-tools/dineroIV)
- **`i386-elf-gcc`**: The cross-compiler targeting the `i386` architecture with ELF output, often used for writing operating systems or bare-metal programs. [**Source code repository**](https://ftp.gnu.org/gnu/gcc)
- **`i386-elf-binutils`**: A collection of binary tools for working with the `i386` architecture and ELF binaries. [**Source code repository**](https://ftp.gnu.org/gnu/binutils)

## How do I install these formulae?

`brew install rennamahcus/tools/<formula>`

Or `brew tap rennamahcus/tools` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "rennamahcus/tools"
brew "<formula>"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
