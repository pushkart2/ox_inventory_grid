import { Slot, SlotWithItem } from '../../web/src/typings/slot';
import { Inventory } from '../../web/src/typings/inventory';
import { ItemData } from '../../web/src/typings/item';
import { State } from '../../web/src/typings/state';

export function makeSlot(overrides?: Partial<Slot>): Slot {
  return { slot: 1, ...overrides };
}

export function makeItem(overrides?: Partial<SlotWithItem>): SlotWithItem {
  return {
    slot: 1,
    name: 'water',
    count: 1,
    weight: 100,
    metadata: {},
    ...overrides,
  };
}

export function makeItemData(overrides?: Partial<ItemData>): ItemData {
  return {
    name: 'water',
    label: 'Water',
    stack: true,
    usable: false,
    close: false,
    count: 0,
    width: 1,
    height: 1,
    ...overrides,
  };
}

export function emptyInventory(): Inventory {
  return { id: '', type: '', slots: 0, maxWeight: 0, items: [] };
}

export function makeInventory(overrides?: Partial<Inventory>): Inventory {
  return {
    id: 'test',
    type: 'stash',
    slots: 50,
    items: [],
    maxWeight: 100000,
    gridWidth: 10,
    gridHeight: 5,
    ...overrides,
  };
}

export function makeState(overrides?: Partial<State>): State {
  return {
    leftInventory: emptyInventory(),
    rightInventory: emptyInventory(),
    backpackInventory: emptyInventory(),
    clothingInventory: emptyInventory(),
    extraInventories: [],
    additionalMetadata: [],
    itemAmount: 0,
    shiftPressed: false,
    isBusy: false,
    dragRotated: false,
    hotbar: [null, null, null, null, null],
    craftQueue: [],
    craftQueueProcessing: false,
    searchState: { searchingSlots: [] },
    ...overrides,
  };
}
