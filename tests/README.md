# ox_inventory Tests

## Overview

This directory contains automated tests for the ox_inventory resource:

- **UI tests** (`tests/ui/`): Unit tests for React hooks, store logic, and helper utilities used by the inventory's NUI (web) layer. These run in a simulated browser environment via Vitest + jsdom.
- **Lua tests** (`tests/lua/`): Unit tests for extracted pure-logic Lua functions that power server/client scripts.

## Prerequisites

- **Node.js 18+** and npm (for UI tests)
- **Lua 5.4 or LuaJIT** (for Lua tests)

Install UI test dependencies from the `web/` directory:

```bash
cd web
npm install
```

## Running UI Tests

All commands are run from the `web/` directory.

**Run all UI tests once:**

```bash
cd web
npm test
```

**Run in watch mode** (re-runs on file changes):

```bash
cd web
npm test -- --watch
```

**Run with coverage report:**

```bash
cd web
npm test -- --coverage
```

**Run a specific test file:**

```bash
cd web
npm test -- tests/ui/hooks/useDebounce.test.ts
```

## Running Lua Tests

From the repository root:

```bash
lua tests/lua/run_tests.lua
```

This executes all Lua test modules and prints results to the console.

## Test Structure

```
tests/
  vitest.config.ts        # Vitest configuration (jsdom environment, glob patterns)
  tsconfig.json           # TypeScript config extending web/tsconfig.json
  ui/
    helpers/              # Tests for pure utility/helper functions
    hooks/                # Tests for React hooks (useImageUrl, useQueue, useDebounce, etc.)
    store/                # Tests for state management logic
    testUtils.ts          # Shared test utilities and mocks
  lua/
    run_tests.lua         # Lua test runner
    ...                   # Lua test modules
```

## Writing New Tests

### UI Test Pattern

Create a `.test.ts` file under the appropriate `tests/ui/` subdirectory:

```typescript
import { describe, it, expect, vi } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { myHook } from '../../../web/src/hooks/myHook';

describe('myHook', () => {
  it('does something expected', () => {
    const { result } = renderHook(() => myHook());
    expect(result.current).toBe(expectedValue);
  });

  it('updates on action', () => {
    const { result } = renderHook(() => myHook());
    act(() => {
      result.current.doSomething();
    });
    expect(result.current.value).toBe(newValue);
  });
});
```

For hooks that use timers, wrap with `vi.useFakeTimers()` / `vi.useRealTimers()` and advance time with `vi.advanceTimersByTime(ms)` inside an `act()` call.

### Lua Test Pattern

Add a new test module in `tests/lua/` and register it in `run_tests.lua`:

```lua
local function test_my_function()
  local result = my_function("input")
  assert(result == "expected", "my_function should return expected")
end

return {
  test_my_function = test_my_function,
}
```

## Keeping Lua Extracted Functions in Sync

Some Lua tests operate on functions extracted (copied) from the main resource scripts into standalone modules so they can be tested without the FiveM runtime. When you modify a source function:

1. Locate the corresponding extracted copy in `tests/lua/`.
2. Update the extracted copy to match the new implementation.
3. Run the Lua tests to verify correctness.

If the function's signature or behavior changes, update both the extracted module and all tests that reference it.

## Common Mocking Patterns

### Mocking the global Image class (for `useImageUrl`)

```typescript
let imageInstances: Array<{ src: string; onload: (() => void) | null; onerror: (() => void) | null }>;

class MockImage {
  src = '';
  onload: (() => void) | null = null;
  onerror: (() => void) | null = null;
  constructor() { imageInstances.push(this as any); }
}

beforeEach(() => {
  imageInstances = [];
  vi.stubGlobal('Image', MockImage);
});
```

Then trigger `onload` or `onerror` on `imageInstances[n]` inside `act()` to simulate image loading.

### Fake timers (for debounce, throttle, intervals)

```typescript
beforeEach(() => vi.useFakeTimers());
afterEach(() => vi.useRealTimers());

// In a test:
act(() => {
  vi.advanceTimersByTime(500);
});
```

### Mocking fetch / NUI callbacks

```typescript
vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
  ok: true,
  json: () => Promise.resolve({ data: 'mock' }),
}));
```
