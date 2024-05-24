# 👀 BinaryPeek

Binary search to peek into a buffer, because why not?

## Features

- Jump up or down within the buffer using binary search
- ~~Waste~~ Save time

## Installation

Lazy:

```lua
{
  "mgastonportillo/binary-peek.nvim",
  event = "VeryLazy",
  init = function()
    -- any mappings should go here
  end
  config = true
}
```

## Configuration

- Might add mapping customisation via opts in the future

## Commands

`:BinaryPeek` Toggle BinaryPeek on/off

Can take arguments:
| Argument | Action |
| - | - |
| start | Start searching |
| stop | Stop search (doesn't return to the original line) |
| abort | Aborts search (returns to the original line) |
| up | Search to the left side of the buffer (upwards) |
| down | Search to the right side of the buffer (downwards) |
| undo | Undo search step (Unimplemented) |
| redo | Redo search step (Unimplemented) |

Example usage: `:BinaryPeek abort`
