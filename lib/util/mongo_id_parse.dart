import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

String? objectIdToJson(ObjectId? objectId) => objectId?.toHexString();
ObjectId objectIdFromJson(ObjectId jsonValue) => jsonValue;
