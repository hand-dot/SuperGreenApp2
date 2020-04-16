/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/towelie/cards/plant/card_plant_tuto_take_pic.dart';
import 'package:super_green_app/towelie/towelie_button.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';

const _id = 'PLANT_BLOOM_STAGE';

class TowelieButtonPlantBloomStage extends TowelieButton {
  @override
  String get id => _id;

  static Map<String, dynamic> createButton() =>
      TowelieButton.createButton(_id, {
        'title': 'Bloom',
      });

  @override
  Stream<TowelieBlocState> buttonPressed(
      TowelieBlocEventButtonPressed event) async* {
    final db = RelDB.get();
    Plant plant = await db.plantsDAO.getPlantWithFeed(event.feed.id);
    Box box = await db.plantsDAO.getBox(plant.box);
    Map<String, dynamic> plantSettings = db.plantsDAO.plantSettings(plant);
    plantSettings['phase'] = 'BLOOM';
    await db.plantsDAO.updatePlant(PlantsCompanion(
        id: Value(plant.id),
        settings: Value(JsonEncoder().convert(plantSettings))));

    final Map<String, dynamic> boxSettings = db.plantsDAO.boxSettings(box);
    if (plantSettings['plantType'] == 'PHOTO') {
      boxSettings['schedule'] = 'BLOOM';
    }
    await db.plantsDAO.updateBox(BoxesCompanion(
        id: Value(box.id),
        settings: Value(JsonEncoder().convert(boxSettings))));

    await CardPlantTutoTakePic.createPlantTutoTakePic(event.feed);
    await removeButtons(event.feedEntry, selectedButtonID: id);
  }
}
