import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three3d/math/vector3.dart';
import 'package:three_dart/three3d/three.dart' as three_dart;
import 'package:three_dart/three_dart.dart' as three;
import 'package:three_dart_jsm/three_dart_jsm.dart' as three_jsm;

const int deskopModeWidth = 640;

// TODO: Load from web
const Map settingData = {
  'camera': {
    'x': -50,
    'y': 25,
    'z': 100,
    'focusX': 12.5,
    'focusY': 0,
    'focusZ': 25,
    'focusIncreaseX': -50,
    'focusIncreaseY': 50,
    'focusIncreaseZ': -50,
  },
  'controls': {'enabled': true, 'autoRotate': true, 'autoRotateSpeed': 2.0},
  'lights': [
    {
      'type': 'ambient',
      'color': 0xffffff,
      'intensity': 1,
    },
    {
      'type': 'directional',
      'color': 0xff8400,
      'intensity': 1,
      'position': {'x': 90, 'y': 80, 'z': 50},
      'target': {'x': 0, 'y': 0, 'z': 0},
      'shadow': {
        'enabled': true,
        'bias': -0.0006,
        'mapSize': {'width': 1024, 'height': 1024},
        'camera': {
          'left': -150,
          'right': 150,
          'top': 150,
          'bottom': -150,
          'near': 0.1,
          'far': 500,
        }
      }
    }
  ],
  'buildings': {
    'randomColor': false,
    'color': 0xa6a7a3,
    'focusColor': 0xaa0000,
    'focusOpacity': 0.5,
    'name': {
      'build': '行政大樓==通達樓',
      'build1': '行政大樓',
      'build2': '通達樓',
      'build3': '中和樓',
      'build4': '至誠樓',
      'build5': '謙融樓',
      'build6': '圖書館',
      'build7': '活動中心',
      'build8': '游泳池',
      'build9': '教師宿舍'
    }
  },
  'object': {
    'set': {
      'build_base1': {'name': '基1', 'searchable': false},
      'build_base2': {'name': '基2', 'searchable': false},
      'build_1f': {'name': '行政大樓==通達樓1F', 'searchable': false},
      'build_2f': {'name': '行政大樓==通達樓2F', 'searchable': false},
      'build_3f': {'name': '行政大樓==通達樓3F', 'searchable': false},
      'build_4f': {'name': '行政大樓==通達樓4F', 'searchable': false},
      'build_5f': {'name': '行政大樓==通達樓5F', 'searchable': false},
      'build_6f': {'name': '行政大樓=x=通達樓6F', 'searchable': false},
      'build_7f': {'name': '行政大樓=x=通達樓7F', 'searchable': false},
      'build_stair': {'name': '行政大樓==通達樓-樓梯'},
      'build1_b1_room1': {'name': '行政大樓B1'},
      'build1_b1_room2': {'name': '行政大樓B1未知空間'},
      'build1_1f_room1': {'name': '學務處'},
      'build1_1f_room2': {'name': '健康中心'},
      'build1_1f_facility1': {'name': 'ATM'}, // TODO: fix search upper case
      'build1_2f_room1': {
        'name': '教務處',
        'description': '這是好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多好多的測試文字'
      },
      'build1_2f_room2': {'name': '輔導室'},
      'build1_3f_room1': {'name': '校長室', 'description': '曾經是大蛇丸的棲息地'},
      'build1_3f_room2': {'name': '總務處'},
      'build1_3f_room3': {'name': '會議室'},
      'build1_4f_room1': {'name': '教師辦公室'},
      'build1_4f_room2': {'name': '家長接待室'},
      'build1_5f_room1': {'name': '自主學習空間'},
      'build1_6f_room1': {'name': '行政大樓6F會議室'},
      'build1_7f_room1': {'name': '桌球室'},
      'build1_1f_room': {'name': '行政大樓1F未知空間'},
      'build1_2f_room': {'name': '行政大樓2F油印室'},
      'build1_3f_room': {'name': '行政大樓3F未知空間'},
      'build1_4f_room': {'name': '行政大樓4F茶水間'},
      'build1_5f_room': {'name': '行政大樓5F未知空間'},
      'build1_6f_room': {'name': '行政大樓6F未知空間'},
      'build1_7f_room': {'name': '行政大樓7F未知空間'},
      'build1_1f_toilet1': {'name': '行政大樓1F廁所'},
      'build1_2f_toilet1': {'name': '行政大樓2F廁所'},
      'build1_3f_toilet1': {'name': '行政大樓3F廁所'},
      'build1_4f_toilet1': {'name': '行政大樓4F廁所'},
      'build1_5f_toilet1': {'name': '行政大樓5F廁所'},
      'build1_6f_toilet1': {'name': '行政大樓6F廁所'},
      'build1_7f_toilet1': {'name': '行政大樓7F廁所'},
      'build1_stair': {'name': '行政大樓樓梯'},
      'build1_elevator': {'name': '行政大樓電梯'},
      'build2_base1': {'name': '通達樓基1', 'searchable': false},
      'build2_1f_room1': {'name': '通達樓1F會議室'},
      'build2_2f_room1': {'name': '生物實驗室1'},
      'build2_3f_room1': {'name': '化學實驗室2'},
      'build2_4f_room1': {'name': '物理實驗室1'},
      'build2_5f_room1': {'name': '烹飪教室'},
      'build2_1f_toilet1': {'name': '通達樓1F廁所'},
      'build2_2f_toilet1': {'name': '通達樓2F廁所'},
      'build2_3f_toilet1': {'name': '通達樓3F廁所'},
      'build2_4f_toilet1': {'name': '通達樓4F廁所'},
      'build2_5f_toilet1': {'name': '通達樓5F廁所'},
      'build3_stair1': {'name': '中和樓樓梯#1'},
      'build3_stair2': {'name': '中和樓樓梯#2'},
      'build3_stair3': {'name': '中和樓樓梯#3'},
      'build3_base1': {'name': '中和樓基1', 'searchable': false},
      'build3_base2': {'name': '中和樓基2', 'searchable': false},
      'build3_base3': {'name': '中和樓基3', 'searchable': false},
      'build3_b1_aisle1': {'name': '早餐店'},
      'build3_b1_room1': {'name': '店1'},
      'build3_b1_room2': {'name': '店2'},
      'build3_b1_room3': {'name': '店3'},
      'build3_b1_room4': {'name': '合作社'},
      'build3_b1_room5': {'name': '中和樓B1未知空間'},
      'build3_1f_room1': {'name': '潛能教室'},
      'build3_1f_room2': {'name': '理化教室'},
      'build3_1f_toilet1': {'name': '中和樓1F廁所#1'},
      'build3_1f_aisle1': {'name': '中和樓1F走道#1', 'searchable': false},
      'build3_1f_room3': {'name': '103教室'},
      'build3_1f_room4': {'name': '102教室'},
      'build3_1f_room5': {'name': '101教室'},
      'build3_1f_room6': {'name': '205教室'},
      'build3_1f_toilet2': {'name': '中和樓1F廁所#2'},
      'build3_2f_room1': {'name': '生物實驗室2'},
      'build3_2f_room2': {'name': '設備組'},
      'build3_2f_toilet1': {'name': '中和樓2F廁所#1'},
      'build3_2f_aisle1': {'name': '中和樓2F走道#1', 'searchable': false},
      'build3_2f_room3': {'name': '113教室'},
      'build3_2f_room4': {'name': '112教室'},
      'build3_2f_room5': {'name': '111教室'},
      'build3_2f_room6': {'name': '110教室'},
      'build3_2f_toilet2': {'name': '中和樓2F廁所#2'},
      'build3_3f_room1': {'name': '化學實驗室2'},
      'build3_3f_room2': {'name': '視聽教室'},
      'build3_3f_toilet1': {'name': '中和樓3F廁所#1'},
      'build3_3f_aisle1': {'name': '中和樓3F走道#1', 'searchable': false},
      'build3_3f_room3': {'name': '118教室'},
      'build3_3f_room4': {'name': '117教室'},
      'build3_3f_room5': {'name': '116教室'},
      'build3_3f_room6': {'name': '115教室'},
      'build3_3f_toilet2': {'name': '中和樓3F廁所#2'},
      'build3_4f_room1': {'name': '物理實驗室2'},
      'build3_4f_room2': {'name': '電腦教室3'},
      'build3_4f_toilet1': {'name': '中和樓4F廁所#1'},
      'build3_4f_aisle1': {'name': '中和樓4F走道#1', 'searchable': false},
      'build3_4f_room3': {'name': '教師辦公室'},
      // 'build3_4f_room4': {'name': ''},
      'build3_4f_room5': {'name': '寰宇教室'},
      'build3_4f_room6': {'name': '國際教室'},
      'build3_4f_toilet2': {'name': '中和樓4F廁所#2'},
      'build3_5f_room1': {'name': '團輔室'},
      'build3_5f_room2': {'name': '電腦教室4'},
      'build3_5f_toilet1': {'name': '中和樓5F廁所#1'},
      'build3_5f_aisle1': {'name': '中和樓5F走道#1', 'searchable': false},
      'build3_5f_room3': {'name': '社科教室'},
      'build3_5f_room4': {'name': '美術教室2'},
      // 'build3_5f_room5': {'name': ''},
      'build3_5f_room6': {'name': '美術教室1'},
      'build3_5f_toilet2': {'name': '中和樓5F廁所#2'},
      'build4_b1_room1': {'name': '至誠樓B1'},
      'build4_b1_room2': {'name': '至誠樓B1未知空間'},
      'build4_1f_room1': {'name': '體育辦公室'},
      'build4_1f_room2': {'name': '體育器材室'},
      'build4_1f_aisle1': {'name': '至誠樓1F穿堂', 'searchable': false},
      'build4_1f_room3': {'name': '教官室'},
      'build4_1f_room4': {'name': '健護教室'},
      'build4_1f_room5': {'name': '社團教室'},
      'build4_1f_room6': {'name': '儲藏室'},
      'build4_1f_aisle2': {'name': '至誠樓1F側郎', 'searchable': false},
      'build4_2f_room1': {'name': '109教室'},
      'build4_2f_room2': {'name': '108教室'},
      'build4_2f_aisle1': {'name': '至誠樓2F穿堂', 'searchable': false},
      'build4_2f_room3': {'name': '107教室'},
      'build4_2f_room4': {'name': '106教室'},
      'build4_2f_room5': {'name': '105教室'},
      'build4_2f_room6': {'name': '104教室'},
      'build4_2f_aisle2': {'name': '至誠樓2F側郎', 'searchable': false},
      'build4_3f_room1': {'name': '114教室'},
      'build4_3f_room2': {'name': '206教室'},
      'build4_3f_aisle1': {'name': '至誠樓3F穿堂', 'searchable': false},
      'build4_3f_room3': {'name': '204教室'},
      'build4_3f_room4': {'name': '203教室'},
      'build4_3f_room5': {'name': '202教室'},
      'build4_3f_room6': {'name': '201教室'},
      'build4_3f_aisle2': {'name': '至誠樓3F側郎', 'searchable': false},
      'build4_4f_room1': {'name': '212教室'},
      'build4_4f_room2': {'name': '211教室'},
      'build4_4f_aisle1': {'name': '至誠樓4F穿堂', 'searchable': false},
      'build4_4f_room3': {'name': '210教室'},
      'build4_4f_room4': {'name': '209教室'},
      'build4_4f_room5': {'name': '208教室'},
      'build4_4f_room6': {'name': '207教室'},
      'build4_4f_aisle2': {'name': '至誠樓4F側郎', 'searchable': false},
      'build4_5f_room1': {'name': '218教室'},
      'build4_5f_room2': {'name': '217教室'},
      'build4_5f_aisle1': {'name': '至誠樓5F穿堂', 'searchable': false},
      'build4_5f_room3': {'name': '216教室'},
      'build4_5f_room4': {'name': '215教室'},
      'build4_5f_room5': {'name': '214教室'},
      'build4_5f_room6': {'name': '213教室'},
      'build4_5f_aisle2': {'name': '至誠樓5F側郎', 'searchable': false},
      'build4_stair1': {'name': '至誠樓樓梯#1'},
      'build5_b1_room1': {'name': '謙融樓B1用餐區'},
      'build5_b1_room2': {'name': '謙融樓B1未知空間'},
      'build5_1f_room1': {'name': '306教室'},
      'build5_1f_room2': {'name': '305教室'},
      'build5_1f_aisle1': {'name': '謙融樓1F穿堂', 'searchable': false},
      'build5_1f_room3': {'name': '304教室'},
      'build5_1f_room4': {'name': '303教室'},
      'build5_1f_room5': {'name': '302教室'},
      'build5_1f_room6': {'name': '301教室'},
      'build5_1f_aisle2': {'name': '謙融樓1F側郎', 'searchable': false},
      'build5_stair1': {'name': '謙融樓樓梯#1'},
      'build5_2f_room1': {'name': '312教室'},
      'build5_2f_room2': {'name': '311教室'},
      'build5_2f_aisle1': {'name': '謙融樓2F穿堂', 'searchable': false},
      'build5_2f_room3': {'name': '310教室'},
      'build5_2f_room4': {'name': '309教室'},
      'build5_2f_room5': {'name': '308教室'},
      'build5_2f_room6': {'name': '307教室'},
      'build5_2f_aisle2': {'name': '謙融樓2F側郎', 'searchable': false},
      'build5_3f_room1': {'name': '318教室'},
      'build5_3f_room2': {'name': '317教室'},
      'build5_3f_aisle1': {'name': '謙融樓3F穿堂', 'searchable': false},
      'build5_3f_room3': {'name': '316教室'},
      'build5_3f_room4': {'name': '315教室'},
      'build5_3f_room5': {'name': '314教室'},
      'build5_3f_room6': {'name': '313教室'},
      'build5_3f_aisle2': {'name': '謙融樓3F側郎', 'searchable': false},
      'build5_4f_room1': {'name': '生科教室'},
      // 'build5_4f_room2': {'name': ''},
      'build5_4f_aisle1': {'name': '創課教室'},
      'build5_4f_room3': {'name': '電腦教室1'},
      // 'build5_4f_room4': {'name': ''},
      'build5_4f_room5': {'name': '電腦教室2'},
      // 'build5_4f_room6': {'name': ''},
      'build5_4f_aisle2': {'name': '謙融樓4F側郎', 'searchable': false},
      'build5_5f_room1': {'name': '星象館'},
      'build5_5f_room2': {'name': '地科實驗室'},
      // 'build5_5f_aisle1': {'name': '謙融樓5F穿堂', 'searchable': false},
      'build5_5f_room3': {'name': '韻律教室'},
      // 'build5_5f_room4': {'name': ''},
      'build5_5f_room5': {'name': '音樂教室1'},
      'build5_5f_room6': {'name': '音樂教室2'},
      'build5_5f_aisle2': {'name': '謙融樓5F側郎', 'searchable': false},
      'build6_base1': {'name': '圖書館基1', 'searchable': false},
      'build6_elevator1': {'name': '圖書館電梯'},
      'build6_stair1': {'name': '圖書館樓梯'},
      'build6_stair2': {'name': '圖書館後樓梯'},
      'build6_1f_toilet1': {'name': '圖書館1F廁所'},
      'build6_1f_room1': {'name': '演藝廳'},
      'build6_1f_room2': {'name': '圖書館1F平台?'},
      'build6_1f_room2_###1': {'name': '圖書館1F平台?#1', 'searchable': false},
      'build6_2f_toilet1': {'name': '圖書館2F廁所'},
      'build6_2f_room2': {'name': 'MIT教室'},
      'build6_2f_room2_###1': {'name': '圖書館2F平台?#1', 'searchable': false},
      'build6_3f_toilet1': {'name': '圖書館3F廁所'},
      'build6_3f_room1': {'name': '圖書館閱覽室'},
      'build6_3f_room1_###1': {'name': '圖書館閱覽室#1', 'searchable': false},
      'build6_3f_room1_###2': {'name': '圖書館閱覽室#2', 'searchable': false},
      'build6_4f_toilet1': {'name': '圖書館4F廁所'},
      'build6_4f_room1': {'name': '圖書館4F???'},
      'build6_4f_room1_###1': {'name': '圖書館4F???#1', 'searchable': false},
      'build6_4f_room1_###2': {'name': '圖書館4F???#2', 'searchable': false},
      'build6_5f_toilet1': {'name': '圖書館5F廁所'},
      'build6_5f_room1': {'name': '圖書館5F???'},
      'build6_5f_room1_###1': {'name': '圖書館5F???#1', 'searchable': false},
      'build6_5f_room1_###2': {'name': '圖書館5F???#2', 'searchable': false},
      'build7_base1': {'name': '活動中心基1', 'searchable': false},
      'build7_toilet1': {'name': '活動中心女廁所'},
      'build7_toilet2': {'name': '活動中心男廁所'},
      'build7_build': {'name': '活動中心'},
      'build8_base1': {'name': '游泳池基1', 'searchable': false},
      'build8_base2': {'name': '游泳池基2', 'searchable': false},
      'build8_base3': {'name': '游泳池基3', 'searchable': false},
      'build8_room1': {'name': '游泳池'},
      'build8_room2': {'name': '游泳池更衣室'},
      'build8_room3': {'name': '游泳池??鍋爐室??'},
      'build9_stair1': {'name': '教師宿舍樓梯'},
      'build9_1f': {'name': '教師宿舍1F'},
      'build9_1f_###1': {'name': '教師宿舍1F#1', 'searchable': false},
      'build9_1f_###2': {'name': '教師宿舍1F#2', 'searchable': false},
      'build9_2f': {'name': '教師宿舍2F'},
      'build9_2f_###1': {'name': '教師宿舍2F#1', 'searchable': false},
      'build9_2f_###2': {'name': '教師宿舍2F#2', 'searchable': false},
      'build9_3f': {'name': '教師宿舍3F'},
      'build9_3f_###1': {'name': '教師宿舍3F#1', 'searchable': false},
      'build9_3f_###2': {'name': '教師宿舍3F#2', 'searchable': false},
      'build9_4f': {'name': '教師宿舍4F'},
      'build9_4f_###1': {'name': '教師宿舍4F#1', 'searchable': false},
      'build9_4f_###2': {'name': '教師宿舍4F#2', 'searchable': false},
      'build9_5f': {'name': '教師宿舍5F'},
      'build9_5f_###1': {'name': '教師宿舍5F#1', 'searchable': false},
      'build9_5f_###2': {'name': '教師宿舍5F#2', 'searchable': false},
      'facility_courtyard1': {'name': '中庭', 'render': false},
      'facility_courtyard2': {'name': '小中庭', 'render': false},
      'facility_gate': {'name': '大門'},
      'facility_gate_###1': {'name': '大門柱#1', 'searchable': false},
      'facility_gate_###2': {'name': '大門柱#2', 'searchable': false},
      'facility_court1': {'name': '籃球場B'},
      'facility_court2': {'name': '排球場'},
      'facility_court3': {'name': '籃球場A'},
      'facility_court4': {'name': '未知場地'},
      'facility_recyclihgYard1': {'name': '回收場'},
      'facility_guardHouse': {'name': '警衛室'},
      'facility_parkingLot1': {'name': '機車棚'},
      'facility_parkingLot1_###1': {'name': '機車棚#1', 'searchable': false},
      'facility_toilet1': {'name': '廁所#獨'},
      'facility_electronic1': {'name': '電箱'},
      'facility_garbages1': {'name': '垃圾場'},
      'facility_electronic2': {'name': '變電所'},
      'facility_platform1': {'name': '司令台'},
      'facility_ground1': {'name': '運動場'},
      'facility_parkingLot2': {'name': '停車場#1', 'render': false},
      'facility_parkingLot3': {'name': '停車場#2', 'render': false},
    }
  },
  'ground': {'color': 0x96ad82, 'width': 200, 'length': 300},
  'background': {
    'color': 'system', // 'system' or 0x000000
  },
};

// build, floor, x, y, z, height, width, length, color, render, rotate, searchable
const Map<String, Map<String, dynamic>> mapData = {
  // build
  'build_base1': {
    'x': 13,
    'y': 0,
    'z': 51.5,
    'height': 1,
    'width': 13,
    'length': 5
  },
  'build_base2': {
    'x': 13,
    'y': 0,
    'z': 61,
    'height': 1,
    'width': 6,
    'length': 5
  },
  'build_1f': {
    'floor': 1,
    'x': 13,
    'y': 1,
    'z': 51.5,
    'height': 4,
    'width': 13,
    'length': 5
  },
  'build_2f': {
    'floor': 2,
    'x': 13,
    'y': 5,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 5
  },
  'build_3f': {
    'floor': 3,
    'x': 13,
    'y': 8,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 5
  },
  'build_4f': {
    'floor': 4,
    'x': 13,
    'y': 11,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 5
  },
  'build_5f': {
    'floor': 5,
    'x': 13,
    'y': 14,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 5
  },
  'build_6f': {
    'floor': 6,
    'x': 13,
    'y': 17,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 5
  },
  'build_7f': {
    'floor': 7,
    'x': 13,
    'y': 20,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 5
  },
  'build_stair': {
    'x': 13,
    'y': 1,
    'z': 61,
    'height': 26,
    'width': 6,
    'length': 5,
  },

  // build1
  // build1_b1
  'build1_b1_room1': {
    'build': 'build1',
    'x': -2,
    'y': -2,
    'z': 60,
    'height': 3,
    'width': 30,
    'length': 25,
    'floor': -1,
  },
  'build1_b1_room2': {
    'build': 'build1',
    'x': 4,
    'y': -2,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 13,
    'floor': -1,
  },
  // build1_1f
  'build1_1f_room': {
    'build': 'build1',
    'x': -1,
    'y': 1,
    'z': 42.5,
    'height': 4,
    'width': 5,
    'length': 3,
    'floor': 1,
  },
  'build1_1f_room1': {
    'build': 'build1',
    'x': 0.5,
    'y': 1,
    'z': 67.5,
    'height': 4,
    'width': 15,
    'length': 20,
    'floor': 1,
  },
  'build1_1f_room2': {
    'build': 'build1',
    'x': 3.5,
    'y': 1,
    'z': 55.5,
    'height': 4,
    'width': 9,
    'length': 10,
    'floor': 1,
  },
  'build1_1f_facility1': {
    'build': 'build1',
    'x': 9.5,
    'y': 1,
    'z': 55.5,
    'height': 4,
    'width': 9,
    'length': 2,
    'floor': 1,
  },
  'build1_1f_toilet1': {
    'build': 'build1',
    'x': 5.5,
    'y': 1,
    'z': 42.5,
    'height': 4,
    'width': 5,
    'length': 10,
    'floor': 1,
  },
  // build1_2f
  'build1_2f_room': {
    'build': 'build1',
    'x': -1,
    'y': 5,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 3,
    'floor': 2,
  },
  'build1_2f_room1': {
    'build': 'build1',
    'x': -2,
    'y': 5,
    'z': 60,
    'height': 3,
    'width': 30,
    'length': 15,
    'floor': 2,
  },
  'build1_2f_room2': {
    'build': 'build1',
    'x': 8,
    'y': 5,
    'z': 60,
    'height': 3,
    'width': 30,
    'length': 5,
    'floor': 2,
  },
  // build1_3f
  'build1_3f_room': {
    'build': 'build1',
    'x': -1,
    'y': 8,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 3,
    'floor': 3,
  },
  'build1_3f_room1': {
    'build': 'build1',
    'x': 4.25,
    'y': 8,
    'z': 61.5,
    'height': 3,
    'width': 27,
    'length': 12.5,
    'floor': 3,
  },
  'build1_3f_room2': {
    'build': 'build1',
    'x': -8.25,
    'y': 8,
    'z': 61.5,
    'height': 3,
    'width': 27,
    'length': 12.5,
    'floor': 3,
  },
  'build1_3f_room3': {
    'build': 'build1',
    'x': -12,
    'y': 8,
    'z': 46.5,
    'height': 3,
    'width': 3,
    'length': 5,
    'floor': 3,
  },
  // build1_4f
  'build1_4f_room': {
    'build': 'build1',
    'x': -1,
    'y': 11,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 3,
    'floor': 4,
  },
  'build1_4f_room1': {
    'build': 'build1',
    'x': -2,
    'y': 11,
    'z': 61.5,
    'height': 3,
    'width': 27,
    'length': 25,
    'floor': 4,
  },
  'build1_4f_room2': {
    'build': 'build1',
    'x': -12,
    'y': 11,
    'z': 46.5,
    'height': 3,
    'width': 3,
    'length': 5,
    'floor': 4,
  },
  // build1_5f
  'build1_5f_room': {
    'build': 'build1',
    'x': -1,
    'y': 14,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 3,
    'floor': 5,
  },
  'build1_5f_room1': {
    'build': 'build1',
    'x': -2,
    'y': 14,
    'z': 60,
    'height': 3,
    'width': 30,
    'length': 25,
    'floor': 5,
  },
  // build1_6f
  'build1_6f_room': {
    'build': 'build1',
    'x': -1,
    'y': 17,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 3,
    'floor': 6,
  },
  'build1_6f_room1': {
    'build': 'build1',
    'x': -2,
    'y': 17,
    'z': 60,
    'height': 3,
    'width': 30,
    'length': 25,
    'floor': 5,
  },
  // build1_7f
  'build1_7f_room': {
    'build': 'build1',
    'x': -1,
    'y': 20,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 3,
    'floor': 7,
  },
  'build1_7f_room1': {
    'build': 'build1',
    'x': -2,
    'y': 20,
    'z': 60,
    'height': 3,
    'width': 30,
    'length': 25,
    'floor': 5,
  },
  'build1_2f_toilet1': {
    'build': 'build1',
    'x': 5.5,
    'y': 5,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 10,
    'floor': 2,
  },
  'build1_3f_toilet1': {
    'build': 'build1',
    'x': 5.5,
    'y': 8,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 10,
    'floor': 3,
  },
  'build1_4f_toilet1': {
    'build': 'build1',
    'x': 5.5,
    'y': 11,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 10,
    'floor': 4,
  },
  'build1_5f_toilet1': {
    'build': 'build1',
    'x': 5.5,
    'y': 14,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 10,
    'floor': 5,
  },
  'build1_6f_toilet1': {
    'build': 'build1',
    'x': 5.5,
    'y': 17,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 10,
    'floor': 6,
  },
  'build1_7f_toilet1': {
    'build': 'build1',
    'x': 5.5,
    'y': 20,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 10,
    'floor': 7,
  },
  'build1_stair': {
    'build': 'build1',
    'x': -10,
    'y': -2,
    'z': 42.5,
    'height': 29,
    'width': 5,
    'length': 9
  },
  'build1_elevator': {
    'build': 'build1',
    'x': -4,
    'y': -2,
    'z': 42.5,
    'height': 29,
    'width': 5,
    'length': 3
  },

  // build2
  'build2_base1': {
    'build': 'build2',
    'x': 28.5,
    'y': 0,
    'z': 51.5,
    'height': 1,
    'width': 13,
    'length': 26
  },
  'build2_1f_room1': {
    'floor': 1,
    'build': 'build2',
    'x': 25,
    'y': 1,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 19
  },
  'build2_2f_room1': {
    'floor': 2,
    'build': 'build2',
    'x': 25,
    'y': 4,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 19
  },
  'build2_3f_room1': {
    'floor': 3,
    'build': 'build2',
    'x': 25,
    'y': 7,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 19
  },
  'build2_4f_room1': {
    'floor': 4,
    'build': 'build2',
    'x': 25,
    'y': 10,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 19
  },
  'build2_5f_room1': {
    'floor': 5,
    'build': 'build2',
    'x': 25,
    'y': 13,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 19
  },
  'build2_1f_toilet1': {
    'floor': 1,
    'build': 'build2',
    'x': 38,
    'y': 1,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 7
  },
  'build2_2f_toilet1': {
    'floor': 2,
    'build': 'build2',
    'x': 38,
    'y': 4,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 7
  },
  'build2_3f_toilet1': {
    'floor': 3,
    'build': 'build2',
    'x': 38,
    'y': 7,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 7
  },
  'build2_4f_toilet1': {
    'floor': 4,
    'build': 'build2',
    'x': 38,
    'y': 10,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 7
  },
  'build2_5f_toilet1': {
    'floor': 5,
    'build': 'build2',
    'x': 38,
    'y': 13,
    'z': 51.5,
    'height': 3,
    'width': 13,
    'length': 7
  },

  // build3
  'build3_stair1': {
    'build': 'build3',
    'x': 45,
    'y': 1,
    'z': 53.5,
    'height': 18,
    'width': 9,
    'length': 7,
  },
  'build3_stair2': {
    'build': 'build3',
    'x': 49.5,
    'y': -2,
    'z': 24,
    'height': 21,
    'width': 16,
    'length': 4,
  },
  'build3_stair3': {
    'build': 'build3',
    'x': 48.5,
    'y': -2,
    'z': -22,
    'height': 21,
    'width': 4,
    'length': 14
  },
  // build3_b1
  'build3_b1_aisle1': {
    'floor': -1,
    'build': 'build3',
    'x': 44.5,
    'y': -2,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_b1_room1': {
    'floor': -1,
    'build': 'build3',
    'x': 49.5,
    'y': -2,
    'z': 13.75,
    'height': 3,
    'width': 4.5,
    'length': 16
  },
  'build3_b1_room2': {
    'floor': -1,
    'build': 'build3',
    'x': 49.5,
    'y': -2,
    'z': 9.25,
    'height': 3,
    'width': 4.5,
    'length': 16
  },
  'build3_b1_room3': {
    'floor': -1,
    'build': 'build3',
    'x': 49.5,
    'y': -2,
    'z': 2.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_b1_room4': {
    'floor': -1,
    'build': 'build3',
    'x': 49.5,
    'y': -2,
    'z': -11,
    'height': 3,
    'width': 18,
    'length': 16
  },
  'build3_b1_room5': {
    'floor': -1,
    'build': 'build3',
    'x': 54.5,
    'y': -2,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_base1': {
    'build': 'build3',
    'x': 40,
    'y': 0,
    'z': 66.5,
    'height': 1,
    'width': 17,
    'length': 11,
    'searchable': false
  },
  'build3_base2': {
    'build': 'build3',
    'x': 47.5,
    'y': 0,
    'z': 40.5,
    'height': 1,
    'width': 17,
    'length': 12
  },
  'build3_base3': {
    'build': 'build3',
    'x': 45,
    'y': 0,
    'z': 53.5,
    'height': 1,
    'width': 9,
    'length': 7,
  },
  // build3_1f
  'build3_1f_room1': {
    'floor': 1,
    'build': 'build3',
    'x': 40,
    'y': 1,
    'z': 66.5,
    'height': 3,
    'width': 17,
    'length': 11
  },
  'build3_1f_room2': {
    'floor': 1,
    'build': 'build3',
    'x': 47.5,
    'y': 1,
    'z': 40.5,
    'height': 3,
    'width': 17,
    'length': 12
  },
  'build3_1f_toilet1': {
    'floor': 1,
    'build': 'build3',
    'x': 54.5,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_1f_aisle1': {
    'floor': 1,
    'build': 'build3',
    'x': 44.5,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_1f_room3': {
    'floor': 1,
    'build': 'build3',
    'x': 49.5,
    'y': 1,
    'z': 11.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_1f_room4': {
    'floor': 1,
    'build': 'build3',
    'x': 49.5,
    'y': 1,
    'z': 2.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_1f_room5': {
    'floor': 1,
    'build': 'build3',
    'x': 49.5,
    'y': 1,
    'z': -6.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_1f_room6': {
    'floor': 1,
    'build': 'build3',
    'x': 49.5,
    'y': 1,
    'z': -15.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_1f_toilet2': {
    'floor': 1,
    'build': 'build3',
    'x': 48.5,
    'y': 1,
    'z': -30,
    'height': 3,
    'width': 12,
    'length': 14
  },
  // build3_2f
  'build3_2f_room1': {
    'floor': 2,
    'build': 'build3',
    'x': 40,
    'y': 4,
    'z': 66.5,
    'height': 3,
    'width': 17,
    'length': 11
  },
  'build3_2f_room2': {
    'floor': 2,
    'build': 'build3',
    'x': 47.5,
    'y': 4,
    'z': 40.5,
    'height': 3,
    'width': 17,
    'length': 12
  },
  'build3_2f_toilet1': {
    'floor': 2,
    'build': 'build3',
    'x': 54.5,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_2f_aisle1': {
    'floor': 2,
    'build': 'build3',
    'x': 44.5,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_2f_room3': {
    'floor': 2,
    'build': 'build3',
    'x': 49.5,
    'y': 4,
    'z': 11.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_2f_room4': {
    'floor': 2,
    'build': 'build3',
    'x': 49.5,
    'y': 4,
    'z': 2.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_2f_room5': {
    'floor': 2,
    'build': 'build3',
    'x': 49.5,
    'y': 4,
    'z': -6.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_2f_room6': {
    'floor': 2,
    'build': 'build3',
    'x': 49.5,
    'y': 4,
    'z': -15.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_2f_toilet2': {
    'floor': 2,
    'build': 'build3',
    'x': 48.5,
    'y': 4,
    'z': -30,
    'height': 3,
    'width': 12,
    'length': 14
  },
  // build3_3f
  'build3_3f_room1': {
    'floor': 3,
    'build': 'build3',
    'x': 40,
    'y': 7,
    'z': 66.5,
    'height': 3,
    'width': 17,
    'length': 11
  },
  'build3_3f_room2': {
    'floor': 3,
    'build': 'build3',
    'x': 47.5,
    'y': 7,
    'z': 40.5,
    'height': 3,
    'width': 17,
    'length': 12
  },
  'build3_3f_toilet1': {
    'floor': 3,
    'build': 'build3',
    'x': 54.5,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_3f_aisle1': {
    'floor': 3,
    'build': 'build3',
    'x': 44.5,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_3f_room3': {
    'floor': 3,
    'build': 'build3',
    'x': 49.5,
    'y': 7,
    'z': 11.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_3f_room4': {
    'floor': 3,
    'build': 'build3',
    'x': 49.5,
    'y': 7,
    'z': 2.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_3f_room5': {
    'floor': 3,
    'build': 'build3',
    'x': 49.5,
    'y': 7,
    'z': -6.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_3f_room6': {
    'floor': 3,
    'build': 'build3',
    'x': 49.5,
    'y': 7,
    'z': -15.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_3f_toilet2': {
    'floor': 3,
    'build': 'build3',
    'x': 48.5,
    'y': 7,
    'z': -30,
    'height': 3,
    'width': 12,
    'length': 14
  },
  // build3_4f
  'build3_4f_room1': {
    'floor': 4,
    'build': 'build3',
    'x': 40,
    'y': 10,
    'z': 66.5,
    'height': 3,
    'width': 17,
    'length': 11
  },
  'build3_4f_room2': {
    'floor': 4,
    'build': 'build3',
    'x': 47.5,
    'y': 10,
    'z': 40.5,
    'height': 3,
    'width': 17,
    'length': 12
  },
  'build3_4f_toilet1': {
    'floor': 4,
    'build': 'build3',
    'x': 54.5,
    'y': 10,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_4f_aisle1': {
    'floor': 4,
    'build': 'build3',
    'x': 44.5,
    'y': 10,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_4f_room3': {
    'floor': 4,
    'build': 'build3',
    'x': 49.5,
    'y': 10,
    'z': 7,
    // 'z': 11.5,
    'height': 3,
    'width': 18,
    // 'width': 9,
    'length': 16
  },
  // 'build3_4f_room4': {
  //   'floor': 4,
  //   'build': 'build3',
  //   'x': 49.5,
  //   'y': 10,
  //   'z': 2.5,
  //   'height': 3,
  //   'width': 9,
  //   'length': 16
  // },
  'build3_4f_room5': {
    'floor': 4,
    'build': 'build3',
    'x': 49.5,
    'y': 10,
    'z': -6.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_4f_room6': {
    'floor': 4,
    'build': 'build3',
    'x': 49.5,
    'y': 10,
    'z': -15.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_4f_toilet2': {
    'floor': 4,
    'build': 'build3',
    'x': 48.5,
    'y': 10,
    'z': -30,
    'height': 3,
    'width': 12,
    'length': 14
  },
  // build3_5f
  'build3_5f_room1': {
    'floor': 5,
    'build': 'build3',
    'x': 40,
    'y': 13,
    'z': 66.5,
    'height': 3,
    'width': 17,
    'length': 11
  },
  'build3_5f_room2': {
    'floor': 5,
    'build': 'build3',
    'x': 47.5,
    'y': 13,
    'z': 40.5,
    'height': 3,
    'width': 17,
    'length': 12
  },
  'build3_5f_toilet1': {
    'floor': 5,
    'build': 'build3',
    'x': 54.5,
    'y': 13,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_5f_aisle1': {
    'floor': 5,
    'build': 'build3',
    'x': 44.5,
    'y': 13,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 6
  },
  'build3_5f_room3': {
    'floor': 5,
    'build': 'build3',
    'x': 49.5,
    'y': 13,
    'z': 11.5,
    'height': 3,
    'width': 9,
    'length': 16
  },
  'build3_5f_room4': {
    'floor': 5,
    'build': 'build3',
    'x': 49.5,
    'y': 13,
    'z': -0.5,
    // 'z': 2.5,
    'height': 3,
    'width': 15,
    // 'width': 9,
    'length': 16
  },
  // 'build3_5f_room5': {
  //   'floor': 5,
  //   'build': 'build3',
  //   'x': 49.5,
  //   'y': 13,
  //   'z': -6.5,
  //   'height': 3,
  //   'width': 9,
  //   'length': 16
  // },
  'build3_5f_room6': {
    'floor': 5,
    'build': 'build3',
    'x': 49.5,
    'y': 13,
    'z': -14,
    // 'z': -15.5,
    'height': 3,
    'width': 12,
    // 'width': 9,
    'length': 16
  },
  'build3_5f_toilet2': {
    'floor': 5,
    'build': 'build3',
    'x': 48.5,
    'y': 13,
    'z': -30,
    'height': 3,
    'width': 12,
    'length': 14
  },

  // build4
  'build4_stair1': {
    'build': 'build4',
    'x': -22,
    'y': -2,
    'z': -19.5,
    'height': 18,
    'width': 10,
    'length': 10
  },
  // build4_b1
  'build4_b1_room1': {
    'floor': -1,
    'build': 'build4',
    'x': 10,
    'y': -2,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 63
  },
  'build4_b1_room2': {
    'floor': -1,
    'build': 'build4',
    'x': 48.5,
    'y': -2,
    'z': -30,
    'height': 3,
    'width': 12,
    'length': 14
  },
  // build4_1f
  'build4_1f_room1': {
    'floor': 1,
    'build': 'build4',
    'x': 37,
    'y': 1,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_1f_room2': {
    'floor': 1,
    'build': 'build4',
    'x': 28,
    'y': 1,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_1f_aisle1': {
    'floor': 1,
    'build': 'build4',
    'x': 21.25,
    'y': 1,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build4_1f_room3': {
    'floor': 1,
    'build': 'build4',
    'x': 14.5,
    'y': 1,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_1f_room4': {
    'floor': 1,
    'build': 'build4',
    'x': 5.5,
    'y': 1,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_1f_room5': {
    'floor': 1,
    'build': 'build4',
    'x': -3.5,
    'y': 1,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_1f_room6': {
    'floor': 1,
    'build': 'build4',
    'x': -12.5,
    'y': 1,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_1f_aisle2': {
    'floor': 1,
    'build': 'build4',
    'x': -19.25,
    'y': 1,
    'z': -30.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build4_2f
  'build4_2f_room1': {
    'floor': 2,
    'build': 'build4',
    'x': 37,
    'y': 4,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_2f_room2': {
    'floor': 2,
    'build': 'build4',
    'x': 28,
    'y': 4,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_2f_aisle1': {
    'floor': 2,
    'build': 'build4',
    'x': 21.25,
    'y': 4,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build4_2f_room3': {
    'floor': 2,
    'build': 'build4',
    'x': 14.5,
    'y': 4,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_2f_room4': {
    'floor': 2,
    'build': 'build4',
    'x': 5.5,
    'y': 4,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_2f_room5': {
    'floor': 2,
    'build': 'build4',
    'x': -3.5,
    'y': 4,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_2f_room6': {
    'floor': 2,
    'build': 'build4',
    'x': -12.5,
    'y': 4,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_2f_aisle2': {
    'floor': 2,
    'build': 'build4',
    'x': -19.25,
    'y': 4,
    'z': -30.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build4_3f
  'build4_3f_room1': {
    'floor': 3,
    'build': 'build4',
    'x': 37,
    'y': 7,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_3f_room2': {
    'floor': 3,
    'build': 'build4',
    'x': 28,
    'y': 7,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_3f_aisle1': {
    'floor': 3,
    'build': 'build4',
    'x': 21.25,
    'y': 7,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build4_3f_room3': {
    'floor': 3,
    'build': 'build4',
    'x': 14.5,
    'y': 7,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_3f_room4': {
    'floor': 3,
    'build': 'build4',
    'x': 5.5,
    'y': 7,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_3f_room5': {
    'floor': 3,
    'build': 'build4',
    'x': -3.5,
    'y': 7,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_3f_room6': {
    'floor': 3,
    'build': 'build4',
    'x': -12.5,
    'y': 7,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_3f_aisle2': {
    'floor': 3,
    'build': 'build4',
    'x': -19.25,
    'y': 7,
    'z': -30.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build4_4f
  'build4_4f_room1': {
    'floor': 4,
    'build': 'build4',
    'x': 37,
    'y': 10,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_4f_room2': {
    'floor': 4,
    'build': 'build4',
    'x': 28,
    'y': 10,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_4f_aisle1': {
    'floor': 4,
    'build': 'build4',
    'x': 21.25,
    'y': 10,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build4_4f_room3': {
    'floor': 4,
    'build': 'build4',
    'x': 14.5,
    'y': 10,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_4f_room4': {
    'floor': 4,
    'build': 'build4',
    'x': 5.5,
    'y': 10,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_4f_room5': {
    'floor': 4,
    'build': 'build4',
    'x': -3.5,
    'y': 10,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_4f_room6': {
    'floor': 4,
    'build': 'build4',
    'x': -12.5,
    'y': 10,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_4f_aisle2': {
    'floor': 4,
    'build': 'build4',
    'x': -19.25,
    'y': 10,
    'z': -30.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build4_5f
  'build4_5f_room1': {
    'floor': 5,
    'build': 'build4',
    'x': 37,
    'y': 13,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_5f_room2': {
    'floor': 5,
    'build': 'build4',
    'x': 28,
    'y': 13,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_5f_aisle1': {
    'floor': 5,
    'build': 'build4',
    'x': 21.25,
    'y': 13,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build4_5f_room3': {
    'floor': 5,
    'build': 'build4',
    'x': 14.5,
    'y': 13,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_5f_room4': {
    'floor': 5,
    'build': 'build4',
    'x': 5.5,
    'y': 13,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_5f_room5': {
    'floor': 5,
    'build': 'build4',
    'x': -3.5,
    'y': 13,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_5f_room6': {
    'floor': 5,
    'build': 'build4',
    'x': -12.5,
    'y': 13,
    'z': -28,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build4_5f_aisle2': {
    'floor': 5,
    'build': 'build4',
    'x': -19.25,
    'y': 13,
    'z': -30.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },

  // build5
  'build5_stair1': {
    'build': 'build5',
    'x': -22,
    'y': -2,
    'z': 15.5,
    'height': 18,
    'width': 10,
    'length': 10
  },
  // build5_b1
  'build5_b1_room1': {
    'floor': -1,
    'build': 'build5',
    'x': 37,
    'y': -2,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_b1_room2': {
    'floor': -1,
    'build': 'build5',
    'x': 5.5,
    'y': -2,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 54
  },
  // build5_1f
  'build5_1f_room1': {
    'floor': 1,
    'build': 'build5',
    'x': 37,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_1f_room2': {
    'floor': 1,
    'build': 'build5',
    'x': 28,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_1f_aisle1': {
    'floor': 1,
    'build': 'build5',
    'x': 21.25,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build5_1f_room3': {
    'floor': 1,
    'build': 'build5',
    'x': 14.5,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_1f_room4': {
    'floor': 1,
    'build': 'build5',
    'x': 5.5,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_1f_room5': {
    'floor': 1,
    'build': 'build5',
    'x': -3.5,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_1f_room6': {
    'floor': 1,
    'build': 'build5',
    'x': -12.5,
    'y': 1,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_1f_aisle2': {
    'floor': 1,
    'build': 'build5',
    'x': -19.25,
    'y': 1,
    'z': 26.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build5_2f
  'build5_2f_room1': {
    'floor': 2,
    'build': 'build5',
    'x': 37,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_2f_room2': {
    'floor': 2,
    'build': 'build5',
    'x': 28,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_2f_aisle1': {
    'floor': 2,
    'build': 'build5',
    'x': 21.25,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build5_2f_room3': {
    'floor': 2,
    'build': 'build5',
    'x': 14.5,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_2f_room4': {
    'floor': 2,
    'build': 'build5',
    'x': 5.5,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_2f_room5': {
    'floor': 2,
    'build': 'build5',
    'x': -3.5,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_2f_room6': {
    'floor': 2,
    'build': 'build5',
    'x': -12.5,
    'y': 4,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_2f_aisle2': {
    'floor': 2,
    'build': 'build5',
    'x': -19.25,
    'y': 4,
    'z': 26.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build5_3f
  'build5_3f_room1': {
    'floor': 3,
    'build': 'build5',
    'x': 37,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_3f_room2': {
    'floor': 3,
    'build': 'build5',
    'x': 28,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_3f_aisle1': {
    'floor': 3,
    'build': 'build5',
    'x': 21.25,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build5_3f_room3': {
    'floor': 3,
    'build': 'build5',
    'x': 14.5,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_3f_room4': {
    'floor': 3,
    'build': 'build5',
    'x': 5.5,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_3f_room5': {
    'floor': 3,
    'build': 'build5',
    'x': -3.5,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_3f_room6': {
    'floor': 3,
    'build': 'build5',
    'x': -12.5,
    'y': 7,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_3f_aisle2': {
    'floor': 3,
    'build': 'build5',
    'x': -19.25,
    'y': 7,
    'z': 26.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build5_4f
  'build5_4f_room1': {
    'floor': 4,
    'build': 'build5',
    'x': 32.5,
    // 'x': 37,
    'y': 10,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 18
    // 'length': 9
  },
  // 'build5_4f_room2': {
  //   'floor': 4,
  //   'build': 'build5',
  //   'x': 28,
  //   'y': 10,
  //   'z': 24,
  //   'height': 3,
  //   'width': 16,
  //   'length': 9
  // },
  'build5_4f_aisle1': {
    'floor': 4,
    'build': 'build5',
    'x': 21.25,
    'y': 10,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 4.5
  },
  'build5_4f_room3': {
    'floor': 4,
    'build': 'build5',
    'x': 10,
    'y': 10,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 18
    // 'length': 9
  },
  // 'build5_4f_room4': {
  //   'floor': 4,
  //   'build': 'build5',
  //   'x': 5.5,
  //   'y': 10,
  //   'z': 24,
  //   'height': 3,
  //   'width': 16,
  //   'length': 9
  // },
  'build5_4f_room5': {
    'floor': 4,
    'build': 'build5',
    'x': -8,
    'y': 10,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 18
    // 'length': 9
  },
  // 'build5_4f_room6': {
  //   'floor': 4,
  //   'build': 'build5',
  //   'x': -12.5,
  //   'y': 10,
  //   'z': 24,
  //   'height': 3,
  //   'width': 16,
  //   'length': 9
  // },
  'build5_4f_aisle2': {
    'floor': 4,
    'build': 'build5',
    'x': -19.25,
    'y': 10,
    'z': 26.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },
  // build5_5f
  'build5_5f_room1': {
    'floor': 5,
    'build': 'build5',
    'x': 37,
    'y': 13,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_5f_room2': {
    'floor': 5,
    'build': 'build5',
    'x': 25.75,
    'y': 13,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 13.5
    // 'length': 9
  },
  // 'build5_5f_aisle1': {
  //   'floor': 5,
  //   'build': 'build5',
  //   'x': 21.25,
  //   'y': 13,
  //   'z': 24,
  //   'height': 3,
  //   'width': 16,
  //   'length': 4.5
  // },
  'build5_5f_room3': {
    'floor': 5,
    'build': 'build5',
    'x': 10,
    'y': 13,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 18
    // 'length': 9
  },
  // 'build5_5f_room4': {
  //   'floor': 5,
  //   'build': 'build5',
  //   'x': 5.5,
  //   'y': 13,
  //   'z': 24,
  //   'height': 3,
  //   'width': 16,
  //   'length': 9
  // },
  'build5_5f_room5': {
    'floor': 5,
    'build': 'build5',
    'x': -3.5,
    'y': 13,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_5f_room6': {
    'floor': 5,
    'build': 'build5',
    'x': -12.5,
    'y': 13,
    'z': 24,
    'height': 3,
    'width': 16,
    'length': 9
  },
  'build5_5f_aisle2': {
    'floor': 5,
    'build': 'build5',
    'x': -19.25,
    'y': 13,
    'z': 26.25,
    'height': 3,
    'width': 11.5,
    'length': 4.5
  },

  // build6
  'build6_base1': {
    'build': 'build6',
    'x': -60,
    'y': 0,
    'z': 0,
    'height': 1,
    'width': 35,
    'length': 25
  },
  'build6_elevator1': {
    'build': 'build6',
    'x': -56,
    'y': 1,
    'z': -8,
    'height': 18,
    'width': 3,
    'length': 3
  },
  'build6_stair1': {
    'build': 'build6',
    'x': -51,
    'y': 1,
    'z': -8,
    'height': 18,
    'width': 3,
    'length': 7
  },
  'build6_stair2': {
    'build': 'build6',
    'x': -73.75,
    'y': 0,
    'z': 0,
    'height': 17,
    'width': 16,
    'length': 2.5
  },
  // build6_1f
  'build6_1f_toilet1': {
    'floor': 1,
    'build': 'build6',
    'x': -52.5,
    'y': 1,
    'z': -13.5,
    'height': 3,
    'width': 8,
    'length': 10
  },
  'build6_1f_room1': {
    'floor': 1,
    'build': 'build6',
    'x': -60,
    'y': 1,
    'z': 11.5,
    'height': 6,
    'width': 12,
    'length': 25
  },
  'build6_1f_room2': {
    'floor': 1,
    'build': 'build6',
    'x': -62.5,
    'y': 1,
    'z': -0.5,
    'height': 3,
    'width': 12,
    'length': 20
  },
  'build6_1f_room2_###1': {
    'floor': 1,
    'build': 'build6',
    'x': -65,
    'y': 1,
    'z': -12,
    'height': 3,
    'width': 11,
    'length': 15
  },
  // build6_2f
  'build6_2f_toilet1': {
    'floor': 1,
    'build': 'build6',
    'x': -52.5,
    'y': 4,
    'z': -13.5,
    'height': 3,
    'width': 8,
    'length': 10
  },
  'build6_2f_room2': {
    'floor': 1,
    'build': 'build6',
    'x': -62.5,
    'y': 4,
    'z': -0.5,
    'height': 3,
    'width': 12,
    'length': 20
  },
  'build6_2f_room2_###1': {
    'floor': 1,
    'build': 'build6',
    'x': -65,
    'y': 4,
    'z': -12,
    'height': 3,
    'width': 11,
    'length': 15
  },
  // build6_3f
  'build6_3f_toilet1': {
    'floor': 1,
    'build': 'build6',
    'x': -52.5,
    'y': 7,
    'z': -13.5,
    'height': 3,
    'width': 8,
    'length': 10
  },
  'build6_3f_room1_###1': {
    'floor': 3,
    'build': 'build6',
    'x': -60,
    'y': 7,
    'z': 11.5,
    'height': 3,
    'width': 12,
    'length': 25
  },
  'build6_3f_room1': {
    'floor': 3,
    'build': 'build6',
    'x': -62.5,
    'y': 7,
    'z': -0.5,
    'height': 3,
    'width': 12,
    'length': 20
  },
  'build6_3f_room1_###2': {
    'floor': 3,
    'build': 'build6',
    'x': -65,
    'y': 7,
    'z': -12,
    'height': 3,
    'width': 11,
    'length': 15
  },
  // build6_4f
  'build6_4f_toilet1': {
    'floor': 1,
    'build': 'build6',
    'x': -52.5,
    'y': 10,
    'z': -13.5,
    'height': 3,
    'width': 8,
    'length': 10
  },
  'build6_4f_room1_###1': {
    'floor': 4,
    'build': 'build6',
    'x': -60,
    'y': 10,
    'z': 11.5,
    'height': 3,
    'width': 12,
    'length': 25
  },
  'build6_4f_room1': {
    'floor': 4,
    'build': 'build6',
    'x': -62.5,
    'y': 10,
    'z': -0.5,
    'height': 3,
    'width': 12,
    'length': 20
  },
  'build6_4f_room1_###2': {
    'floor': 4,
    'build': 'build6',
    'x': -65,
    'y': 10,
    'z': -12,
    'height': 3,
    'width': 11,
    'length': 15
  },
  // build6_5f
  'build6_5f_toilet1': {
    'floor': 1,
    'build': 'build6',
    'x': -52.5,
    'y': 13,
    'z': -13.5,
    'height': 3,
    'width': 8,
    'length': 10
  },
  'build6_5f_room1_###1': {
    'floor': 5,
    'build': 'build6',
    'x': -60,
    'y': 13,
    'z': 11.5,
    'height': 3,
    'width': 12,
    'length': 25
  },
  'build6_5f_room1': {
    'floor': 5,
    'build': 'build6',
    'x': -62.5,
    'y': 13,
    'z': -0.5,
    'height': 3,
    'width': 12,
    'length': 20
  },
  'build6_5f_room1_###2': {
    'floor': 5,
    'build': 'build6',
    'x': -65,
    'y': 13,
    'z': -12,
    'height': 3,
    'width': 11,
    'length': 15
  },

  // build7
  'build7_base1': {
    'build': 'build7',
    'x': -75,
    'y': 0,
    'z': 60,
    'height': 1,
    'width': 50,
    'length': 35
  },
  'build7_toilet1': {
    'build': 'build7',
    'x': -82.5,
    'y': 1,
    'z': 38,
    'height': 3,
    'width': 5,
    'length': 5
  },
  'build7_toilet2': {
    'build': 'build7',
    'x': -67.5,
    'y': 1,
    'z': 38,
    'height': 3,
    'width': 5,
    'length': 5
  },
  'build7_build': {
    'build': 'build7',
    'x': -75,
    'y': 1,
    'z': 60,
    'height': 10,
    'width': 50,
    'length': 35
  },

  // build8
  'build8_base1': {
    'build': 'build8',
    'x': 70,
    'y': 0,
    'z': -85,
    'height': 1,
    'width': 35,
    'length': 23
  },
  'build8_base2': {
    'build': 'build8',
    'x': 88,
    'y': 0,
    'z': -72.5,
    'height': 1,
    'width': 25,
    'length': 13
  },
  'build8_base3': {
    'build': 'build8',
    'x': 70,
    'y': 0,
    'z': -63.75,
    'height': 1,
    'width': 7.5,
    'length': 23
  },
  'build8_room1': {
    'build': 'build8',
    'x': 70,
    'y': 1,
    'z': -85,
    'height': 6,
    'width': 35,
    'length': 23
  },
  'build8_room2': {
    'build': 'build8',
    'x': 88,
    'y': 1,
    'z': -72.5,
    'height': 4,
    'width': 25,
    'length': 13
  },
  'build8_room3': {
    'build': 'build8',
    'x': 70,
    'y': 0,
    'z': -105,
    'height': 3,
    'width': 5,
    'length': 23
  },

  // build9
  'build9_stair1': {
    'build': 'build9',
    'x': 80,
    'y': 0,
    'z': -45,
    'height': 21,
    'width': 6,
    'length': 6
  },
  // build9_1f
  'build9_1f': {
    'floor': 1,
    'build': 'build9',
    'x': 77,
    'y': 0,
    'z': -42,
    'height': 3,
    'width': 0,
    'length': 0
  },
  'build9_1f_###1': {
    'floor': 1,
    'build': 'build9',
    'x': 70.5,
    'y': 0,
    'z': -47.5,
    'height': 3,
    'width': 11,
    'length': 13
  },
  'build9_1f_###2': {
    'floor': 1,
    'build': 'build9',
    'x': 82.5,
    'y': 0,
    'z': -35.5,
    'height': 3,
    'width': 13,
    'length': 11
  },
  // build9_2f
  'build9_2f': {
    'floor': 2,
    'build': 'build9',
    'x': 77,
    'y': 3,
    'z': -42,
    'height': 3,
    'width': 0,
    'length': 0
  },
  'build9_2f_###1': {
    'floor': 2,
    'build': 'build9',
    'x': 70.5,
    'y': 3,
    'z': -47.5,
    'height': 3,
    'width': 11,
    'length': 13
  },
  'build9_2f_###2': {
    'floor': 2,
    'build': 'build9',
    'x': 82.5,
    'y': 3,
    'z': -35.5,
    'height': 3,
    'width': 13,
    'length': 11
  },
  // build9_3f
  'build9_3f': {
    'floor': 3,
    'build': 'build9',
    'x': 77,
    'y': 6,
    'z': -42,
    'height': 3,
    'width': 0,
    'length': 0
  },
  'build9_3f_###1': {
    'floor': 3,
    'build': 'build9',
    'x': 70.5,
    'y': 6,
    'z': -47.5,
    'height': 3,
    'width': 11,
    'length': 13
  },
  'build9_3f_###2': {
    'floor': 3,
    'build': 'build9',
    'x': 82.5,
    'y': 6,
    'z': -35.5,
    'height': 3,
    'width': 13,
    'length': 11
  },
  // build9_4f
  'build9_4f': {
    'floor': 4,
    'build': 'build9',
    'x': 77,
    'y': 9,
    'z': -42,
    'height': 3,
    'width': 0,
    'length': 0
  },
  'build9_4f_###1': {
    'floor': 4,
    'build': 'build9',
    'x': 70.5,
    'y': 9,
    'z': -47.5,
    'height': 3,
    'width': 11,
    'length': 13
  },
  'build9_4f_###2': {
    'floor': 4,
    'build': 'build9',
    'x': 82.5,
    'y': 9,
    'z': -35.5,
    'height': 3,
    'width': 13,
    'length': 11
  },
  // build9_5f
  'build9_5f': {
    'floor': 5,
    'build': 'build9',
    'x': 77,
    'y': 12,
    'z': -42,
    'height': 3,
    'width': 0,
    'length': 0
  },
  'build9_5f_###1': {
    'floor': 5,
    'build': 'build9',
    'x': 70.5,
    'y': 12,
    'z': -47.5,
    'height': 3,
    'width': 11,
    'length': 13
  },
  'build9_5f_###2': {
    'floor': 5,
    'build': 'build9',
    'x': 82.5,
    'y': 12,
    'z': -35.5,
    'height': 3,
    'width': 13,
    'length': 11
  },

  // facility
  'facility_courtyard1': {
    'x': 10,
    'y': 0,
    'z': -2,
    'height': 0,
    'width': 0,
    'length': 0
  },
  'facility_courtyard2': {
    'x': 20,
    'y': 0,
    'z': 38,
    'height': 0,
    'width': 0,
    'length': 0
  },
  'facility_gate': {
    'x': -30,
    'y': 7,
    'z': 100,
    'height': 3,
    'width': 8,
    'length': 20
  },
  'facility_gate_###1': {
    'x': -37,
    'y': 0,
    'z': 100,
    'height': 7,
    'width': 6,
    'length': 4
  },
  'facility_gate_###2': {
    'x': -23,
    'y': 0,
    'z': 100,
    'height': 7,
    'width': 6,
    'length': 4
  },
  'facility_court1': {
    'x': 40,
    'y': 0,
    'z': -60,
    'height': 0.1,
    'width': 35,
    'length': 30
  },
  'facility_court2': {
    'x': 0,
    'y': 0,
    'z': -62.5,
    'height': 0.1,
    'width': 30,
    'length': 50
  },
  'facility_court3': {
    'x': -50,
    'y': 0,
    'z': -50,
    'height': 0.1,
    'width': 35,
    'length': 30
  },
  'facility_court4': {
    'x': -60,
    'y': 0,
    'z': -85,
    'height': 0.1,
    'width': 15,
    'length': 12,
    'rotate': {'x': 0, 'y': -0.5, 'z': 0}
  },
  'facility_recyclihgYard1': {
    'x': -80,
    'y': 0,
    'z': 0,
    'height': 0.1,
    'width': 35,
    'length': 10
  },
  'facility_guardHouse': {
    'x': -44,
    'y': 0,
    'z': 100,
    'height': 3,
    'width': 5,
    'length': 10
  },
  'facility_parkingLot1': {
    'x': -75,
    'y': 0,
    'z': 98,
    'height': 2,
    'width': 15,
    'length': 36,
    'rotate': {'x': 0, 'y': 0.05, 'z': 0}
  },
  'facility_parkingLot1_###1': {
    'x': -78,
    'y': 0,
    'z': 87,
    'height': 2,
    'width': 2,
    'length': 30
  },
  'facility_toilet1': {
    'x': -80,
    'y': 0,
    'z': 25.5,
    'height': 3,
    'width': 9,
    'length': 11
  },
  'facility_electronic1': {
    'x': 25,
    'y': 0,
    'z': 103,
    'height': 2,
    'width': 3,
    'length': 10
  },
  'facility_garbages1': {
    'x': 35.5,
    'y': 0,
    'z': 103,
    'height': 0.1,
    'width': 3,
    'length': 11
  },
  'facility_electronic2': {
    'x': 72,
    'y': 0,
    'z': -3,
    'height': 3,
    'width': 8,
    'length': 13,
    'rotate': {'x': 0, 'y': 1.2, 'z': 0}
  },
  'facility_platform1': {
    'x': 0,
    'y': 0,
    'z': -135,
    'height': 8,
    'width': 6,
    'length': 14
  },
  'facility_ground1': {
    'x': 0,
    'y': 0,
    'z': -105,
    'height': 0.1,
    'width': 50,
    'length': 100
  },
  'facility_parkingLot2': {
    'x': 23,
    'y': 0,
    'z': 75,
    'height': 0.1,
    'width': 30,
    'length': 20
  },
  'facility_parkingLot3': {
    'x': 75,
    'y': 0,
    'z': -20,
    'height': 0.1,
    'width': 15,
    'length': 20
  },
};

class ZHSH3DMapPage extends StatefulWidget {
  @override
  _ZHSH3DMapPageState createState() => _ZHSH3DMapPageState();
}

class _ZHSH3DMapPageState extends State<ZHSH3DMapPage> {
  Map<String, String> dNameToName = {};
  Map<String, String> nameToDName = {};

  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;

  bool _lightHelper = kDebugMode;
  bool _groundHelper = kDebugMode;

  Timer? _navigatorTimer;

  int? fboId;
  late double width;
  late double height;

  String _selectedLocation = '';
  String _selectedLocationName = '';

  Size? screenSize;

  late three.Scene scene;
  late three.Camera camera;
  late three.Mesh mesh;

  double dpr = 1.0;

  var amount = 4;

  bool verbose = true;
  bool disposed = false;

  late three.WebGLRenderTarget renderTarget;

  dynamic sourceTexture;

  final GlobalKey<three_jsm.DomLikeListenableState> _globalKey =
      GlobalKey<three_jsm.DomLikeListenableState>();

  late three_jsm.OrbitControls controls;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (MediaQuery.of(context).size.width > deskopModeWidth) {
      width = MediaQuery.of(context).size.width / 3 * 2;
      height =
          MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    } else {
      width = MediaQuery.of(context).size.width;
      height =
          (MediaQuery.of(context).size.height - AppBar().preferredSize.height) *
              2 /
              3;
    }

    three3dRender = FlutterGlPlugin();

    Map<String, dynamic> options = {
      'antialias': true,
      'alpha': false,
      'width': width.toInt(),
      'height': height.toInt(),
      'dpr': dpr
    };

    await three3dRender.initialize(options: options);

    setState(() {
      dNameToName = {
        for (var i in mapData.keys)
          settingData['object']['set'][i]['searchable'] == false
              ? ''
              : settingData['object']['set'][i]['name']: i
      };
      nameToDName = {
        for (var i in mapData.keys)
          settingData['object']['set'][i]['searchable'] == false ? '' : i:
              settingData['object']['set'][i]['name']
      };
    });

    Future.delayed(const Duration(milliseconds: 100), () async {
      await three3dRender.prepareContext();

      initScene();
    });
  }

  initSize(BuildContext context) async {
    if (screenSize != null) {
      return;
    }
    final mqd = MediaQuery.of(context);
    screenSize = mqd.size;
    dpr = mqd.devicePixelRatio;

    initPlatformState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZHSH 3D Map'),
      ),
      body: MediaQuery.of(context).size.width > deskopModeWidth
          ? _buildDesktop(context)
          : _buildMobile(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigatorTimer?.cancel();
          resetCamera();
          resetLayout();
          resetBuilgingColor();
        },
        tooltip: 'reset location',
        child: const Icon(Icons.home),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      children: [
        three_jsm.DomLikeListenable(
            key: _globalKey,
            builder: (BuildContext context) {
              return Container(
                  width: width,
                  height: height,
                  child: Builder(builder: (BuildContext context) {
                    return three3dRender.isInitialized
                        ? HtmlElementView(
                            viewType: three3dRender.textureId!.toString())
                        : const Center(child: CircularProgressIndicator());
                  }));
            }),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          padding: const EdgeInsets.all(16.0),
          child: _contentWidget(),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        three_jsm.DomLikeListenable(
            key: _globalKey,
            builder: (BuildContext context) {
              return Container(
                  width: width,
                  height: height,
                  child: Builder(builder: (BuildContext context) {
                    return three3dRender.isInitialized
                        ? HtmlElementView(
                            viewType: three3dRender.textureId!.toString())
                        : Center(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: LinearProgressIndicator(
                                minHeight: 20,
                                backgroundColor: Theme.of(context).splashColor,
                                value: null,
                              ),
                            ),
                          );
                  }));
            }),
        Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            child: _contentWidget())
      ],
    ));
  }

  Widget _contentWidget() {
    return Column(children: [
      InputDecorator(
        decoration: InputDecoration(
          labelText: '搜尋地點',
          prefixIcon: const Icon(Icons.pin_drop),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Autocomplete(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return dNameToName.keys.where((String option) {
              var result = option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
              return result;
            });
          },
          onSelected: (String selection) {
            var name = dNameToName[selection];
            if (kDebugMode) {
              print('You just selected Display Name: $selection, Name: $name');
            }
            search(name!);
          },
        ),
      ),
      Offstage(
        offstage: _selectedLocation == '',
        child: ListTile(
            title: const Text('地點'), trailing: Text('$_selectedLocationName')),
      ),
      Offstage(
        offstage: _selectedLocation == '' ||
            mapData[_selectedLocation]!['build'] == null ||
            settingData['buildings']!['name']
                    [mapData[_selectedLocation]!['build']] ==
                null,
        child: ListTile(
          title: const Text('建築'),
          trailing: Text(
              '${_selectedLocation == '' ? '' : settingData['buildings']!['name'][mapData[_selectedLocation]!['build']] ?? 'None'}'),
        ),
      ),
      Offstage(
        offstage: _selectedLocation == '' ||
            mapData[_selectedLocation]!['floor'] == null,
        child: ListTile(
          title: const Text('樓層'),
          trailing: Text(
              '${_selectedLocation == '' ? '' : mapData[_selectedLocation]!['floor'] ?? 'None'}'
                  .replaceAll('-', 'B')),
        ),
      ),
      Offstage(
          offstage: _selectedLocation == '' ||
              settingData['object']['set'][_selectedLocation]['description'] ==
                  null,
          child: ListTile(
            title: const Text('詳細資訊'),
            subtitle: Text(
                '${_selectedLocation == '' ? '' : settingData['object']['set'][_selectedLocation]['description']}'),
          ))
    ]);
  }

  render() {
    int t = DateTime.now().millisecondsSinceEpoch;
    final gl = three3dRender.gl;
    controls.update();
    renderer!.render(scene, camera);
    int t1 = DateTime.now().millisecondsSinceEpoch;
    if (verbose) {
      if (kDebugMode) {
        print('render cost: ${t1 - t} ');
        print(renderer!.info.memory);
        print(renderer!.info.render);
      }
    }
    // 重要 更新纹理之前一定要调用 确保gl程序执行完毕
    gl.flush();
    // var pixels = _gl.readCurrentPixels(0, 0, 10, 10);
    // print(' --------------pixels............. ');
    // print(pixels);
    if (verbose) {
      if (kDebugMode) {
        print(' render: sourceTexture: $sourceTexture ');
      }
    }
  }

  search(String location) {
    setState(() {
      _selectedLocation = location;
      _selectedLocationName = nameToDName[location]!;
    });
    focus(location);
  }

  initRenderer() {
    Map<String, dynamic> options = {
      'width': width,
      'height': height,
      'gl': three3dRender.gl,
      'antialias': true,
      'canvas': three3dRender.element
    };
    renderer = three.WebGLRenderer(options);
    renderer!.setPixelRatio(dpr);
    renderer!.setSize(width, height, false);
    renderer!.shadowMap.enabled = true;
    renderer!.shadowMap.type = three.PCFSoftShadowMap;
  }

  initScene() {
    initRenderer();
    initPage();
  }

  initPage() {
    scene = three.Scene();
    scene.background = three.Color(
        settingData['background']['color'] == 'system'
            ? Theme.of(context).colorScheme.background.value
            : settingData['background']['color']);
    scene.fog = three.FogExp2(0xcccccc, 0.002);

    camera = three.PerspectiveCamera(60, width / height, 1, 1000);
    camera.position.set(settingData['camera']['x'], settingData['camera']['y'],
        settingData['camera']['z']);
    camera.lookAt(Vector3(settingData['camera']['focusX'],
        settingData['camera']['focusY'], settingData['camera']['focusZ']));

    // controls
    controls = three_jsm.OrbitControls(camera, _globalKey);
    controls.enabled = settingData['controls']['enabled'];
    controls.enableDamping =
        true; // an animation loop is required when either damping or auto-rotation are enabled
    controls.autoRotate = settingData['controls']['autoRotate'];
    controls.autoRotateSpeed = settingData['controls']['autoRotateSpeed'];
    controls.dampingFactor = 0.05;
    controls.screenSpacePanning = false;
    controls.minDistance = 1;
    controls.maxDistance = 500;
    controls.maxPolarAngle = three.Math.pi / 2;
    controls.target.set(settingData['camera']['focusX'],
        settingData['camera']['focusY'], settingData['camera']['focusZ']);

    // world
    var geometry = three.BoxGeometry(1, 1, 1);
    geometry.translate(0, 0.5, 0);
    var material = three.MeshPhongMaterial({'flatShading': true});

    // for (var i = 0; i < 500; i++) {
    //   var mesh = three.Mesh(geometry, material);
    //   mesh.position.x = three.Math.random() * 1600 - 800;
    //   mesh.position.y = 0;
    //   mesh.position.z = three.Math.random() * 1600 - 800;
    //   mesh.scale.x = 20;
    //   mesh.scale.y = three.Math.random() * 80 + 10;
    //   mesh.scale.z = 20;
    //   mesh.updateMatrix();
    //   mesh.matrixAutoUpdate = false;
    //   scene.add(mesh);
    // }

    // var kDebugMode = false;
    // helper
    if (_groundHelper) {
      var grid = three.GridHelper(1000, 1000, 0xff0000, 0xffff);
      scene.add(grid);
      var cameraHelper = three.CameraHelper(camera);
      scene.add(cameraHelper);
      var axesHelper = three_dart.AxesHelper(3);
      scene.add(axesHelper);
    }

    // ground
    if (!_groundHelper) {
      var mesh = three.Mesh(
          three.PlaneGeometry(
              settingData['ground']['width'], settingData['ground']['length']),
          three.MeshPhongMaterial({'color': settingData['ground']['color']}));
      mesh.rotation.x = -three.Math.pi / 2;
      mesh.castShadow = false;
      mesh.receiveShadow = true;
      mesh.name = 'ground';
      scene.add(mesh);
    }

    // buildings
    for (var i in mapData.keys) {
      // for import obj file
      if (settingData['object']['set'][i]['render'] == false) {
        continue;
      }
      var material = three.MeshPhysicalMaterial({
        'color': settingData['buildings']['randomColor'] == true
            ? (three.Math.random() * 0xffffff).toInt()
            : settingData['object']['set'][i]!['color'] ??
                settingData['buildings']['color'],
        'flatShading': false,
        'roughness': 0.1,
        'metalness': 0.1,
      });
      var mesh = three.Mesh(geometry, material);
      mesh.position.x = mapData[i]!['x'];
      mesh.position.y = mapData[i]!['y'];
      mesh.position.z = mapData[i]!['z'];
      mesh.scale.x = mapData[i]!['length'];
      mesh.scale.y = mapData[i]!['height'];
      mesh.scale.z = mapData[i]!['width'];
      mesh.castShadow = true;
      mesh.receiveShadow = true;
      if (mapData[i]!['rotate'] != null) {
        mesh.rotateX(mapData[i]!['rotate']!['x']);
        mesh.rotateY(mapData[i]!['rotate']!['y']);
        mesh.rotateZ(mapData[i]!['rotate']!['z']);
      }
      if (RegExp(r'.*_###[0-9]').allMatches(i).isNotEmpty) {
        mesh.name = i.replaceAll(RegExp(r'_###[0-9]'), '');
      } else {
        mesh.name = i;
      }
      mesh.updateMatrix();
      mesh.matrixAutoUpdate = false;
      scene.add(mesh);
      if (kDebugMode) {
        print('mesh: $mesh');
      }
    }

    // lights
    for (var i in settingData['lights']) {
      if (i['type'] == 'ambient') {
        var ambientLight = three.AmbientLight(i['color']);
        ambientLight.intensity = i['intensity'];
        scene.add(ambientLight);
      } else if (i['type'] == 'directional') {
        var dirLight = three.DirectionalLight(i['color']);
        dirLight.position
            .set(i['position']['x'], i['position']['y'], i['position']['z']);
        dirLight.intensity = i['intensity'];
        if (i['shadow']['enabled']) {
          dirLight.castShadow = i['shadow']['enabled'];
          dirLight.shadow!.camera!.near = i['shadow']['camera']['near'];
          dirLight.shadow!.camera!.far = i['shadow']['camera']['far'];
          dirLight.shadow!.camera!.right = i['shadow']['camera']['right'];
          dirLight.shadow!.camera!.left = i['shadow']['camera']['left'];
          dirLight.shadow!.camera!.top = i['shadow']['camera']['top'];
          dirLight.shadow!.camera!.bottom = i['shadow']['camera']['bottom'];
          dirLight.shadow!.mapSize.width = i['shadow']['mapSize']['width'];
          dirLight.shadow!.mapSize.height = i['shadow']['mapSize']['height'];
          dirLight.shadow!.bias = i['shadow']['bias'];
        }
        scene.add(dirLight);
        if (_lightHelper) {
          var dirLightHelper = three.DirectionalLightHelper(dirLight, 5);
          scene.add(dirLightHelper);
        }
      }
    }

    animate();
  }

  animate() {
    if (!mounted || disposed) {
      return;
    }

    render();

    Future.delayed(const Duration(milliseconds: 40), () {
      animate();
    });
  }

  focus(String buildingName) {
    if (controls.autoRotate) {
      controls.autoRotate = false;
    }
    if (_navigatorTimer != null) {
      _navigatorTimer!.cancel();
    }
    var objectX = mapData[buildingName]!['x'];
    var objectY = mapData[buildingName]!['y'];
    var objectZ = mapData[buildingName]!['z'];
    var objectHeight = mapData[buildingName]!['height'];
    var tarCameraPosition = three.Vector3(
      objectX >= 0
          ? objectX - settingData['camera']['focusIncreaseX']
          : objectX + settingData['camera']['focusIncreaseX'],
      objectY + (objectHeight / 2) + settingData['camera']['focusIncreaseY'],
      objectZ >= 0
          ? objectZ - settingData['camera']['focusIncreaseZ']
          : objectZ + settingData['camera']['focusIncreaseZ'],
    );
    _navigatorTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || disposed) {
        timer.cancel();
        return;
      }
      var cameraPosition = camera.position;
      var distance = cameraPosition.distanceTo(tarCameraPosition);
      if (distance < 1) {
        timer.cancel();
        controls.autoRotate = settingData['controls']['autoRotate'];
        return;
      } else {
        // TODO: Best route
        cameraPosition.lerp(tarCameraPosition, 0.1);
      }
      controls.target.set(objectX, objectY + (objectHeight / 2), objectZ);
    });
    for (var i in scene.children) {
      if (i is three.Mesh) {
        if (i.name == 'ground') {
          continue;
        }
        if (i.name == buildingName) {
          if (settingData['object']['set'][i.name]!['render'] == false) {
            continue;
          }
          i.material = three.MeshPhongMaterial({
            'color': settingData['buildings']['focusColor'],
            'flatShading': true,
            'opacity': 1,
            'transparent': false,
          });
        } else {
          i.material = three.MeshPhongMaterial({
            'color': settingData['object']['set'][i.name]!['color'] ??
                settingData['buildings']['color'],
            'flatShading': true,
            'opacity': settingData['buildings']['focusOpacity'],
            'transparent': true,
          });
        }
      }
    }
  }

  resetCamera() {
    if (controls.autoRotate) {
      controls.autoRotate = false;
    }
    var x = settingData['camera']['focusX'];
    var y = settingData['camera']['focusY'];
    var z = settingData['camera']['focusZ'];
    var tarCameraPosition = three.Vector3(settingData['camera']['x'],
        settingData['camera']['y'], settingData['camera']['z']);
    _navigatorTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || disposed) {
        timer.cancel();
        return;
      }
      var cameraPosition = camera.position;
      var distance = cameraPosition.distanceTo(tarCameraPosition);
      if (distance < 1) {
        timer.cancel();
        controls.autoRotate = settingData['controls']['autoRotate'];
        return;
      } else {
        // TODO: Best route
        cameraPosition.lerp(tarCameraPosition, 0.1);
      }
      controls.target.set(x, y, z);
    });
  }

  resetLayout() {
    setState(() {
      _selectedLocation = '';
      _selectedLocationName = '';
    });
  }

  resetBuilgingColor() {
    for (var i in scene.children) {
      if (i.name == 'ground') {
        continue;
      }
      if (i is three.Mesh) {
        i.material = three.MeshPhongMaterial({
          'color': settingData['buildings']['randomColor'] == true
              ? (three.Math.random() * 0xffffff).toInt()
              : settingData['object']['set'][i.name]!['color'] ??
                  settingData['buildings']['color'],
          'flatShading': true,
          'opacity': 1,
          'transparent': false,
        });
      }
    }
  }

  initData() {
    // TODO: init data from web
    print('TODO: initData');
  }

  @override
  void dispose() {
    disposed = true;
    three3dRender.dispose();
    _navigatorTimer?.cancel();

    super.dispose();
  }
}
