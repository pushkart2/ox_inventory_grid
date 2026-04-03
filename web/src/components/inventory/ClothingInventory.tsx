import GridInventory from './GridInventory';
import { useAppSelector } from '../../store';
import { selectClothingInventory } from '../../store/inventory';

const ClothingInventory: React.FC = () => {
  const clothingInventory = useAppSelector(selectClothingInventory);

  return (
    <GridInventory
      inventory={clothingInventory}
      canSort={false}
    />
  );
};

export default ClothingInventory;
