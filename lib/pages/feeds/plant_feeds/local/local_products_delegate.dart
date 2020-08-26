import 'dart:async';

import 'package:moor/moor.dart';
import 'package:super_green_app/data/api/backend/products/models.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/products/products_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/box_settings.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/common/settings/plant_settings.dart';

class LocalProductsBlocDelegate extends ProductsBlocDelegate {
  Box box;
  Plant plant;

  StreamSubscription<Box> boxStream;
  StreamSubscription<Plant> plantStream;

  LocalProductsBlocDelegate(this.plant);

  @override
  void loadProducts() async {
    plant = await RelDB.get().plantsDAO.getPlant(plant.id);
    box = await RelDB.get().plantsDAO.getBox(plant.box);
    plantStream =
        RelDB.get().plantsDAO.watchPlant(plant.id).listen(plantUpdated);
    boxStream = RelDB.get().plantsDAO.watchBox(plant.box).listen(boxUpdated);
    productsLoaded(PlantSettings.fromJSON(plant.settings),
        BoxSettings.fromJSON(box.settings));
  }

  @override
  Stream<ProductsBlocState> updateProducts(List<Product> products) async* {
    List<Product> boxProducts = [];
    List<Product> plantProducts = [];

    for (Product product in products) {
      if (plantProductCategories.contains(product.category)) {
        plantProducts.add(product);
      } else {
        boxProducts.add(product);
      }
    }

    String plantSettingsJSON = PlantSettings.fromJSON(plant.settings)
        .copyWith(products: plantProducts)
        .toJSON();
    String boxSettingsJSON = BoxSettings.fromJSON(box.settings)
        .copyWith(products: boxProducts)
        .toJSON();

    if (plant.settings != plantSettingsJSON) {
      PlantsCompanion plant = PlantsCompanion(
          id: Value(this.plant.id),
          settings: Value(plantSettingsJSON),
          synced: Value(false));
      await RelDB.get().plantsDAO.updatePlant(plant);
    }
    if (box.settings != boxSettingsJSON) {
      BoxesCompanion box = BoxesCompanion(
          id: Value(this.box.id),
          settings: Value(boxSettingsJSON),
          synced: Value(false));
      await RelDB.get().plantsDAO.updateBox(box);
    }
  }

  void plantUpdated(Plant plant) {
    this.plant = plant;
    productsLoaded(PlantSettings.fromJSON(plant.settings),
        BoxSettings.fromJSON(box.settings));
  }

  void boxUpdated(Box box) {
    this.box = box;
    productsLoaded(PlantSettings.fromJSON(plant.settings),
        BoxSettings.fromJSON(box.settings));
  }

  @override
  Future<void> close() async {
    await boxStream.cancel();
    await plantStream.cancel();
  }
}
