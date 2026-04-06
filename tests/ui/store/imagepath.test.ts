import { describe, it, expect, beforeEach } from 'vitest';

import * as mod from '../../../web/src/store/imagepath';

describe('imagepath store', () => {
  // Note: because imagepath is a module-level let, mutations persist across tests.
  // We reset it before each test by calling setImagePath with the default value.
  beforeEach(() => {
    mod.setImagePath('images');
  });

  it('has a default value of "images"', () => {
    expect(mod.imagepath).toBe('images');
  });

  it('updates imagepath with a valid string', () => {
    mod.setImagePath('custom/path');
    expect(mod.imagepath).toBe('custom/path');
  });

  it('does not update imagepath with an empty string', () => {
    mod.setImagePath('custom/path');
    mod.setImagePath('');
    expect(mod.imagepath).toBe('custom/path');
  });

  it('does not update imagepath with a falsy value', () => {
    mod.setImagePath('valid');
    // @ts-expect-error testing falsy input
    mod.setImagePath(undefined);
    expect(mod.imagepath).toBe('valid');
  });
});
