import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three3d/helpers/index.dart';
import 'package:three_dart/three3d/math/vector3.dart';
import 'package:three_dart/three3d/three.dart' as three_dart;
import 'package:three_dart/three_dart.dart' as three;
import 'package:three_dart_jsm/three_dart_jsm.dart' as three_jsm;
import 'package:url_launcher/url_launcher.dart';

const int deskopModeWidth = 640;

const Map settingData = {
  'version': {'name': 'Ver2023.3.11'},
  'general': {
    'devMode': {'openDuration': 5},
    'search': {
      // nameSearch: contains
      // keywordSearch: allmatch
      // descriptionSearch: contains
      // here is global setting
      'descriptionSearch': false,
      'keywordSearch': true,
      'nameSearch': true,
    }
  },
  'camera': {
    'x': -50,
    'y': 25,
    'z': 100,
    'focusX': 12.5,
    'focusY': 0,
    'focusZ': 25,
    'focusIncreaseX': 25,
    'focusIncreaseY': 25,
    'focusIncreaseZ': 25,
    'focusLerp': 0.25
  },
  'controls': {
    'enabled': true,
    'autoRotate': false,
    'autoRotateSpeed': 2.0,
    'searchFocus': true,
  },
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
        'mapSize': {'width': 2048, 'height': 2048},
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
      // Example:
      // 'id': {
      //   'name': 'name',
      //   'description': 'description',
      //   'keyword': ['keyword1', 'keyword2'],
      //   'color': 0x000000, // single object color
      //   'link': {
      //     'link1name': 'link1url',
      //     'link2name': 'link2url',
      //   },
      //   'searchable':
      //       bool, // if false, this object will not be searched, no matter what the next three are
      //   'nameSearch': bool, // true or null to use global setting
      //   'keywordSearch': bool, // true or null to use global setting
      //   'descriptionSearch': bool, // true or null to use global setting
      // },
      'build_base2': {'name': '基2', 'searchable': false},
      'build_1f': {'name': '行政大樓==通達樓1F', 'searchable': false},
      'build_2f': {'name': '行政大樓==通達樓2F', 'searchable': false},
      'build_3f': {'name': '行政大樓==通達樓3F', 'searchable': false},
      'build_4f': {'name': '行政大樓==通達樓4F', 'searchable': false},
      'build_5f': {'name': '行政大樓==通達樓5F', 'searchable': false},
      'build_6f': {'name': '行政大樓=x=通達樓6F', 'searchable': false},
      'build_7f': {'name': '行政大樓=x=通達樓7F', 'searchable': false},
      'build_stair': {'name': '行政大樓==通達樓-樓梯', 'searchable': false},
      'build1_b1_room1': {
        'name': '行政大樓B1',
        'keyword': ['行政大樓地下室', '地下室']
      },
      'build1_b1_room1_###1': {'name': '行政大樓B1未知空間', 'searchable': false},
      'build1_b1_room1_###extend': {'name': '行政大樓B1延伸空間', 'searchable': false},
      'build1_1f_room1': {
        'name': '學務處',
        'description': '訓育組、社團活動組、衛生組、生輔組、教官',
        'link': {
          '學務處網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/studentaffairs',
          '教官室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/military'
        },
        'keyword': ['訓育組', '社團活動組', '衛生組', '生輔組', '教官']
      },
      'build1_1f_room2': {
        'name': '健康中心',
        'keyword': ['保健室']
      },
      'build1_1f_facility1': {
        'name': 'ATM自動櫃員機',
        'description': '中華郵政',
        'keyword': ['中華郵政', '郵局', '提款機']
      },
      'build1_2f_room1': {
        'name': '教務處',
        'description': '教學組、註冊組、試務組、實研組',
        'keyword': ['教學組', '註冊組', '試務組', '實研組'],
        'link': {
          '教務處網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/teacheraffairs'
        }
      },
      'build1_2f_room2': {
        'name': '輔導處',
        'link': {
          '輔導處網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/consultation'
        }
      },
      'build1_3f_room1': {
        'name': '總務處 / 人事室',
        'description': '文書組、事務組、出納組',
        'keyword': ['文書組', '事務組', '出納組', '出納'],
        'link': {
          '總務處網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/generalaffairs',
          '人事室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/personnel'
        }
      },
      'build1_3f_room2': {
        'name': '校長室 / 秘書室',
        'link': {
          '校長室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/principal'
        }
      },
      'build1_3f_room3': {
        'name': '會計室',
        'link': {
          '會計室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/acc'
        }
      },
      'build1_2f_room4': {'name': '簡報室'},
      'build1_4f_room1': {
        'name': '教師辦公室',
        'keyword': ['大辦']
      },
      'build1_4f_room2': {'name': '家長接待室'},
      'build1_5f_room1': {'name': '自主學習空間'},
      'build1_6f_room1': {'name': '大型會議室'},
      'build1_7f_room1': {'name': '文康中心'},
      'build1_1f_room': {'name': '行政大樓1F未知空間', 'searchable': false},
      'build1_2f_room': {'name': '行政大樓2F油印室'},
      'build1_3f_room': {'name': '行政大樓3F未知空間', 'searchable': false},
      'build1_4f_room': {'name': '行政大樓4F茶水間'},
      'build1_5f_room': {'name': '行政大樓5F未知空間', 'searchable': false},
      'build1_6f_room': {'name': '行政大樓6F未知空間', 'searchable': false},
      'build1_7f_room': {'name': '行政大樓7F未知空間', 'searchable': false},
      'build1_1f_toilet1': {'name': '行政大樓1F廁所', 'searchable': false},
      'build1_2f_toilet1': {'name': '行政大樓2F廁所', 'searchable': false},
      'build1_3f_toilet1': {'name': '行政大樓3F廁所', 'searchable': false},
      'build1_4f_toilet1': {'name': '行政大樓4F廁所', 'searchable': false},
      'build1_5f_toilet1': {'name': '行政大樓5F廁所', 'searchable': false},
      'build1_6f_toilet1': {'name': '行政大樓6F廁所', 'searchable': false},
      'build1_7f_toilet1': {'name': '行政大樓7F廁所', 'searchable': false},
      'build1_stair': {'name': '行政大樓樓梯', 'searchable': false},
      'build1_elevator': {'name': '行政大樓電梯', 'searchable': false},
      'build2_base1': {'name': '通達樓基1', 'searchable': false},
      'build2_1f_room1': {'name': '中型會議室'},
      'build2_2f_room1': {'name': '生物實驗室1'},
      'build2_3f_room1': {'name': '化學實驗室2'},
      'build2_4f_room1': {'name': '物理實驗室1'},
      'build2_5f_room1': {'name': '烹飪教室'},
      'build2_1f_toilet1': {'name': '通達樓1F廁所', 'searchable': false},
      'build2_2f_toilet1': {'name': '通達樓2F廁所', 'searchable': false},
      'build2_3f_toilet1': {'name': '通達樓3F廁所', 'searchable': false},
      'build2_4f_toilet1': {'name': '通達樓4F廁所', 'searchable': false},
      'build2_5f_toilet1': {'name': '通達樓5F廁所', 'searchable': false},
      'build3_stair1': {'name': '中和樓樓梯#1', 'searchable': false},
      'build3_stair2': {'name': '中和樓樓梯#2', 'searchable': false},
      'build3_stair3': {'name': '中和樓樓梯#3', 'searchable': false},
      'build3_base1': {'name': '中和樓基1', 'searchable': false},
      'build3_base2': {'name': '中和樓基2', 'searchable': false},
      'build3_base3': {'name': '中和樓基3', 'searchable': false},
      'build3_b1_aisle1': {'name': '早餐店'},
      'build3_b1_room1': {'name': '店1'}, // TODO: name
      'build3_b1_room2': {'name': '店2'}, // TODO: name
      'build3_b1_room3': {'name': '店3'}, // TODO: name
      'build3_b1_room4': {'name': '合作社'},
      'build3_b1_room5': {'name': '中和樓B1未知空間', 'searchable': false},
      'build3_1f_room1': {'name': '潛能教室'},
      'build3_1f_room2': {'name': '理化教室'},
      'build3_1f_toilet1': {'name': '中和樓1F廁所#1', 'searchable': false},
      'build3_1f_aisle1': {'name': '中和樓1F走道#1', 'searchable': false},
      'build3_1f_room3': {'name': '103教室'},
      'build3_1f_room4': {'name': '102教室'},
      'build3_1f_room5': {'name': '101教室'},
      'build3_1f_room6': {'name': '205教室'},
      'build3_1f_toilet2': {'name': '中和樓1F廁所#2', 'searchable': false},
      'build3_2f_room1': {'name': '生物實驗室2'},
      'build3_2f_room2': {'name': '設備組'},
      'build3_2f_toilet1': {'name': '中和樓2F廁所#1', 'searchable': false},
      'build3_2f_aisle1': {'name': '中和樓2F走道#1', 'searchable': false},
      'build3_2f_room3': {'name': '113教室'},
      'build3_2f_room4': {'name': '112教室'},
      'build3_2f_room5': {'name': '111教室'},
      'build3_2f_room6': {'name': '110教室'},
      'build3_2f_toilet2': {'name': '中和樓2F廁所#2', 'searchable': false},
      'build3_3f_room1': {'name': '化學實驗室2'},
      'build3_3f_room2': {'name': '視聽教室'},
      'build3_3f_toilet1': {'name': '中和樓3F廁所#1', 'searchable': false},
      'build3_3f_aisle1': {'name': '中和樓3F走道#1', 'searchable': false},
      'build3_3f_room3': {'name': '118教室'},
      'build3_3f_room4': {'name': '117教室'},
      'build3_3f_room5': {'name': '116教室'},
      'build3_3f_room6': {'name': '115教室'},
      'build3_3f_toilet2': {'name': '中和樓3F廁所#2', 'searchable': false},
      'build3_4f_room1': {'name': '物理實驗室2'},
      'build3_4f_room2': {'name': '電腦教室3'},
      'build3_4f_toilet1': {'name': '中和樓4F廁所#1', 'searchable': false},
      'build3_4f_aisle1': {'name': '中和樓4F走道#1', 'searchable': false},
      'build3_4f_room3': {
        'name': '專任辦公室',
        'keywords': ['小辦公室', '小辦']
      },
      // 'build3_4f_room4': {'name': ''},
      'build3_4f_room5': {'name': '寰宇教室'},
      'build3_4f_room6': {'name': '國際教室'},
      'build3_4f_toilet2': {'name': '中和樓4F廁所#2', 'searchable': false},
      'build3_5f_room1': {'name': '團輔室'},
      'build3_5f_room2': {'name': '電腦教室4'},
      'build3_5f_toilet1': {'name': '中和樓5F廁所#1', 'searchable': false},
      'build3_5f_aisle1': {'name': '中和樓5F走道#1', 'searchable': false},
      'build3_5f_room3': {'name': '社科教室'},
      'build3_5f_room4': {'name': '美術教室2'},
      // 'build3_5f_room5': {'name': ''},
      'build3_5f_room6': {'name': '美術教室1'},
      'build3_5f_toilet2': {'name': '中和樓5F廁所#2', 'searchable': false},
      'build4_b1_room1': {
        'name': '至誠樓B1',
        'description': '生存遊戲社',
        'keyword': ['生存遊戲社', '生存遊戲', '地下室']
      },
      'build4_b1_room1_###1': {'name': '至誠樓B1cc', 'searchable': false},
      'build4_1f_room1': {
        'name': '體育辦公室',
        'keywords': ['體辦']
      },
      'build4_1f_room2': {'name': '體育器材室'},
      'build4_1f_aisle1': {'name': '至誠樓1F穿堂', 'searchable': false},
      'build4_1f_room3': {
        'name': '教官室',
        'link': {
          '教官室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/military'
        }
      },
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
      'build4_stair1': {'name': '至誠樓樓梯#1', 'searchable': false},
      'build5_b1_room1': {
        'name': 'B1用餐區',
        'keyword': ['地下室']
      },
      'build5_b1_room2': {'name': '謙融樓B1未知空間', 'searchable': false},
      'build5_1f_room1': {'name': '306教室'},
      'build5_1f_room2': {'name': '305教室'},
      'build5_1f_aisle1': {'name': '謙融樓1F穿堂', 'searchable': false},
      'build5_1f_room3': {'name': '304教室'},
      'build5_1f_room4': {'name': '303教室'},
      'build5_1f_room5': {'name': '302教室'},
      'build5_1f_room6': {'name': '301教室'},
      'build5_1f_aisle2': {'name': '謙融樓1F側郎', 'searchable': false},
      'build5_stair1': {'name': '謙融樓樓梯#1', 'searchable': false},
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
      'build5_5f_room1': {
        'name': '星象館',
        'keyword': ['天文館', '望遠鏡']
      },
      'build5_5f_room1_###1': {'name': '星象館上層', 'searchable': false},
      'build5_5f_room1_###2': {'name': '星象館頂部半球體', 'searchable': false},
      'build5_5f_room2': {'name': '地科實驗室'},
      // 'build5_5f_aisle1': {'name': '謙融樓5F穿堂', 'searchable': false},
      'build5_5f_room3': {'name': '韻律教室'},
      // 'build5_5f_room4': {'name': ''},
      'build5_5f_room5': {'name': '音樂教室1'},
      'build5_5f_room6': {'name': '音樂教室2'},
      'build5_5f_aisle2': {'name': '謙融樓5F側郎', 'searchable': false},
      'build6_base1': {'name': '圖書館基1', 'searchable': false},
      'build6_elevator1': {'name': '圖書館電梯', 'searchable': false},
      'build6_stair1': {'name': '圖書館樓梯', 'searchable': false},
      'build6_stair2': {'name': '圖書館後樓梯', 'searchable': false},
      'build6_1f_toilet1': {'name': '圖書館1F廁所', 'searchable': false},
      'build6_1f_room1': {'name': '演藝廳'},
      'build6_1f_room2': {'name': '圖書館展覽區'},
      'build6_1f_room3': {'name': '圖書館會議室'},
      'build6_1f_room4': {
        'name': '圖書館辦公區',
        'description': '資訊媒體組',
        'keyword': ['資訊媒體組', '資訊組', '資訊'],
      },
      'build6_1f_room5': {'name': 'TED講堂'},
      'build6_2f_toilet1': {'name': '圖書館閉架書庫區'},
      'build6_2f_room2': {'name': 'MIT教室'},
      'build6_2f_room2_###1': {'name': '圖書館2F平台?#1', 'searchable': false},
      'build6_3f_toilet1': {'name': '圖書館3F廁所', 'searchable': false},
      'build6_3f_room1': {'name': '圖書館閱覽室'},
      'build6_3f_room1_###1': {'name': '圖書館閱覽室#1', 'searchable': false},
      'build6_3f_room1_###2': {'name': '圖書館閱覽室#2', 'searchable': false},
      'build6_4f_toilet1': {'name': '圖書館4F廁所', 'searchable': false},
      'build6_3f_room1_###3': {'name': '圖書館閱覽室#3', 'searchable': false},
      'build6_3f_room1_###4': {'name': '圖書館閱覽室#4', 'searchable': false},
      'build6_4f_room3': {'name': 'MOOCs教室'},
      'build6_4f_room4': {'name': 'ICT教室'},
      'build6_4f_room5': {'name': '電腦機房'},
      'build6_5f_toilet1': {'name': '圖書館5F廁所', 'searchable': false},
      'build6_5f_room1': {'name': '自造空間'},
      'build6_5f_room1_###1': {'name': '圖書館5F???#1', 'searchable': false},
      'build6_5f_room1_###2': {'name': '圖書館5F???#2', 'searchable': false},
      'build7_base1': {'name': '活動中心基1', 'searchable': false},
      'build7_toilet1': {'name': '活動中心女廁所', 'searchable': false},
      'build7_toilet2': {'name': '活動中心男廁所', 'searchable': false},
      'build7_build': {'name': '活動中心', 'description': '籃球場、羽球場'},
      'build8_base1': {'name': '游泳池基1', 'searchable': false},
      'build8_base2': {'name': '游泳池基2', 'searchable': false},
      'build8_base3': {'name': '游泳池基3', 'searchable': false},
      'build8_room1': {'name': '游泳池'},
      'build8_room2': {'name': '游泳池更衣室'},
      'build8_room3': {'name': '游泳池旁空間', 'searchable': false},
      'build9_stair1': {'name': '教師宿舍樓梯', 'searchable': false},
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
      'facility_court4': {'name': '未知用途球場'},
      'facility_recyclihgYard1': {'name': '回收場'},
      'facility_guardHouse': {'name': '警衛室'},
      'facility_parkingLot1': {'name': '機車棚'},
      'facility_parkingLot1_###1': {'name': '機車棚#1', 'searchable': false},
      'facility_toilet1': {
        'name': '百萬廁所',
        'keyword': ['百萬廁所'],
        'description': '民國89年以貳佰參拾玖萬伍仟元建成',
        'nameSearch': false,
        'link': {
          '決標公告':
              'https://web.pcc.gov.tw/tps/atm/AtmAwardWithoutSso/QueryAtmAwardDetail?pkAtmMain=MjM1NzU4'
        }
      },
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

// build, floor, x, y, z, height, width, length, color, render, rotate, nameSearch
const Map<String, Map<String, dynamic>> mapData = {
  // build
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
  'build1_b1_room1_###1': {
    'build': 'build1',
    'x': 4,
    'y': -2,
    'z': 42.5,
    'height': 3,
    'width': 5,
    'length': 13,
    'floor': -1,
  },
  'build1_b1_room1_###extend': {
    'x': 13,
    'y': -2,
    'z': 49,
    'height': 3,
    'width': 18,
    'length': 5
  },
  // build1_1f
  'build1_1f_room': {
    'build': 'build1',
    'x': 9,
    'y': 1,
    'z': 42.5,
    'height': 4,
    'width': 5,
    'length': 3,
    'floor': 1,
    // cccccc
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
    'x': 2.5,
    'y': 1,
    'z': 42.5,
    'height': 4,
    'width': 5,
    'length': 10,
    'floor': 1,
    // cccccc
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
    'z': 62,
    'height': 3,
    'width': 26,
    'length': 15,
    'floor': 2,
  },
  'build1_2f_room2': {
    'build': 'build1',
    'x': 8,
    'y': 5,
    'z': 61,
    'height': 3,
    'width': 28,
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
    'x': -2,
    'y': 8,
    'z': 62,
    'height': 3,
    'width': 26,
    'length': 15,
    'floor': 3,
  },
  'build1_3f_room2': {
    'build': 'build1',
    'x': -12,
    'y': 8,
    'z': 62,
    'height': 3,
    'width': 26,
    'length': 5,
    'floor': 3,
  },
  'build1_3f_room3': {
    'build': 'build1',
    'x': -12,
    'y': 8,
    'z': 47,
    'height': 3,
    'width': 4,
    'length': 5,
    'floor': 3,
  },
  'build1_2f_room4': {
    'build': 'build1',
    'x': 8,
    'y': 8,
    'z': 61,
    'height': 3,
    'width': 28,
    'length': 5,
    'floor': 2,
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
    'z': 61,
    'height': 3,
    'width': 28,
    'length': 25,
    'floor': 4,
  },
  'build1_4f_room2': {
    'build': 'build1',
    'x': -12,
    'y': 11,
    'z': 46,
    'height': 3,
    'width': 2,
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
  'build4_b1_room1_###1': {
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
  'build5_5f_room1_###1': {
    'floor': 6,
    'build': 'build5',
    'x': 37,
    'y': 16,
    'z': 25.5,
    'height': 5,
    'width': 13,
    'length': 9
  },
  'build5_5f_room1_###2': {
    'floor': 6,
    'build': 'build5',
    'x': 37,
    'y': 21,
    'z': 24,
    'radius': 3,
    'shape': 'ball'
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
    'x': -57.5,
    'y': 1,
    'z': -0.5,
    'height': 3,
    'width': 12,
    'length': 10
  },
  'build6_1f_room3': {
    'floor': 1,
    'build': 'build6',
    'x': -67.5,
    'y': 1,
    'z': -0.5,
    'height': 3,
    'width': 12,
    'length': 10
  },
  'build6_1f_room4': {
    'floor': 1,
    'build': 'build6',
    'x': -67.5,
    'y': 1,
    'z': -12,
    'height': 3,
    'width': 11,
    'length': 10
  },
  'build6_1f_room5': {
    'floor': 1,
    'build': 'build6',
    'x': -60,
    'y': 1,
    'z': -12,
    'height': 3,
    'width': 11,
    'length': 5
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
  'build6_4f_room3': {
    'floor': 4,
    'build': 'build6',
    'x': -52.5,
    'y': 10,
    'z': 12.5,
    'height': 3,
    'width': 10,
    'length': 10
  },
  'build6_4f_room4': {
    'floor': 4,
    'build': 'build6',
    'x': -65,
    'y': 10,
    'z': 12.5,
    'height': 3,
    'width': 10,
    'length': 15
  },
  'build6_4f_room5': {
    'floor': 4,
    'build': 'build6',
    'x': -50,
    'y': 10,
    'z': 6.5,
    'height': 3,
    'width': 2,
    'length': 5
  },
  'build6_3f_room1_###3': {
    'floor': 4,
    'build': 'build6',
    'x': -62.5,
    'y': 10,
    'z': 0.5,
    'height': 3,
    'width': 14,
    'length': 20
  },
  'build6_3f_room1_###4': {
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
  const ZHSH3DMapPage({super.key});

  @override
  _ZHSH3DMapPageState createState() => _ZHSH3DMapPageState();
}

class _ZHSH3DMapPageState extends State<ZHSH3DMapPage> {
  Map<String, String> dNameToName = {};
  Map<String, String> nameToDName = {};

  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;

  final bool _lightHelper = kDebugMode;
  final bool _groundHelper = kDebugMode;

  Timer? _navigatorTimer;
  Timer? _devModeTimer;
  Timer? _windowSizeTimer;

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

  bool _devMode = false;
  bool _fullScreen = false;

  int _fps = 0;

  static const String _notFoundText = '找不到地點';
  bool _notFound = false;

  Vector3 _cameraPosition = Vector3(0, 0, 0);
  Vector3 _cameraTarget = Vector3(0, 0, 0);

  @override
  void initState() {
    _windowSizeTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (screenSize != MediaQuery.of(context).size) {
        if (MediaQuery.of(context).size.width > deskopModeWidth) {
          width = MediaQuery.of(context).size.width / 3 * 2;
          height = MediaQuery.of(context).size.height -
              (_fullScreen ? 0 : AppBar().preferredSize.height);
        } else {
          width = MediaQuery.of(context).size.width;
          height = (MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height) *
              2 /
              3;
        }
        camera.aspect = width / height;
        camera.updateProjectionMatrix();
        screenSize = MediaQuery.of(context).size;
      }
    });
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (MediaQuery.of(context).size.width > deskopModeWidth) {
      width = MediaQuery.of(context).size.width / 3 * 2;
      height = MediaQuery.of(context).size.height -
          (_fullScreen ? 0 : AppBar().preferredSize.height);
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
          // settingData['object']['set'][i]['nameSearch'] == false
          //     ? ''
          //     : settingData['object']['set'][i]['name']: i
          settingData['object']['set'][i]['name']: i
      };
      nameToDName = {
        for (var i in mapData.keys)
          // settingData['object']['set'][i]['nameSearch'] == false ? '' : i:
          //     settingData['object']['set'][i]['name']
          i: settingData['object']['set'][i]['name']
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
  }

  @override
  Widget build(BuildContext context) {
    initSize(context);
    return Scaffold(
      appBar: _fullScreen
          ? null
          : AppBar(
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
              return SizedBox(
                  width: width,
                  height: height,
                  child: Builder(builder: (BuildContext context) {
                    return three3dRender.isInitialized
                        ? HtmlElementView(
                            viewType: three3dRender.textureId!.toString())
                        : const Center(child: CircularProgressIndicator());
                  }));
            }),
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            padding: const EdgeInsets.all(16.0),
            child: _contentWidget(),
          ),
        )
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
              return SizedBox(
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
      Autocomplete<String>(
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (String value) {
              var search = searchRecommend(value, true);
              if (search == 'NotFound') {
                setState(() {
                  _notFound = true;
                });
              } else {
                setState(() {
                  _notFound = false;
                });
              }
              onFieldSubmitted();
            },
            onEditingComplete: onFieldSubmitted,
            decoration: InputDecoration(
              labelText: '搜尋地點',
              hintText: '請輸入關鍵字',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  textEditingController.clear();
                },
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              errorText: _notFound ? _notFoundText : null,
              errorBorder: _notFound
                  ? OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error))
                  : null,
            ),
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            setState(() {
              _notFound = false;
            });
            return const Iterable<String>.empty();
          }
          var search = searchRecommend(textEditingValue.text, false);
          if (search == 'NA') {
            setState(() {
              _notFound = false;
            });
            return const Iterable<String>.empty();
          } else if (search == 'NotFound') {
            setState(() {
              _notFound = true;
            });
            return const Iterable<String>.empty();
          } else {
            setState(() {
              _notFound = false;
            });
            return search;
          }
        },
        onSelected: (String selection) {
          if (kDebugMode) {
            print('You just selected Display Name: $selection');
          }
          var id = search(selection);
          if (settingData['controls']['searchFocus'] == true) {
            focus(id);
          }
          // focus(id);
        },
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Column(
            children: [
              Offstage(
                offstage: _selectedLocation == '',
                child: ListTile(
                    title: const Text('地點'),
                    trailing: Text(_selectedLocationName)),
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
                      settingData['object']['set'][_selectedLocation]
                              ['description'] ==
                          null,
                  child: ListTile(
                    title: const Text('詳細資訊'),
                    subtitle: Text(
                        '${_selectedLocation == '' ? '' : settingData['object']['set'][_selectedLocation]['description']}'),
                  )),
              Offstage(
                  offstage: _selectedLocation == '' ||
                      settingData['object']['set'][_selectedLocation]['link'] ==
                          null,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _selectedLocation == '' ||
                                settingData['object']['set'][_selectedLocation]
                                        ['link'] ==
                                    null
                            ? const []
                            : [
                                for (var link in settingData['object']['set']
                                        [_selectedLocation]['link']
                                    .keys)
                                  ElevatedButton(
                                    onPressed: settingData['object']['set']
                                                    [_selectedLocation]['link']
                                                [link]
                                            .isEmpty
                                        ? null
                                        : () {
                                            launchUrl(Uri.parse(
                                                settingData['object']['set']
                                                        [_selectedLocation]
                                                    ['link'][link]));
                                          },
                                    child: Text(link),
                                  ),
                              ]),
                  )),
              const Text('ALL RIGHTS RESERVED © 2023 JHIHYULIN.LIVE',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: _devMode
            ? () {
                setState(() {
                  _devMode = false;
                });
                _devModeTimer?.cancel();
              }
            : null,
        onPanCancel: _devModeTimer?.cancel,
        onPanDown: (DragDownDetails details) {
          _devModeTimer = Timer(
              Duration(
                  seconds: settingData['general']['devMode']['openDuration']),
              () {
            setState(() {
              _devMode = true;
            });
            _devModeTimer?.cancel();
          });
        },
        child: Chip(
          label: Text('${settingData['version']['name']}'),
        ),
      ),
      Offstage(
          offstage: _devMode == false,
          child: Column(
            children: [
              const Text('Press 5 seconds to open'),
              const Text('Short tap to close'),
              ListTile(
                title: const Text('全螢幕'),
                trailing: Switch(
                  value: _fullScreen,
                  onChanged: (bool value) {
                    if (value) {
                      html.document.documentElement!.requestFullscreen();
                      setState(() {
                        _fullScreen = value;
                      });
                    } else {
                      html.document.exitFullscreen();
                      setState(() {
                        _fullScreen = value;
                      });
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Render Cost'),
                trailing: Text('$_fps ms'),
              ),
              ListTile(
                title: const Text('Camera Position'),
                trailing: Text('${_cameraPosition.x.toStringAsFixed(2)}, '
                    '${_cameraPosition.y.toStringAsFixed(2)}, '
                    '${_cameraPosition.z.toStringAsFixed(2)}'),
              ),
              ListTile(
                title: const Text('Camera Target'),
                trailing: Text('${_cameraTarget.x.toStringAsFixed(2)}, '
                    '${_cameraTarget.y.toStringAsFixed(2)}, '
                    '${_cameraTarget.z.toStringAsFixed(2)}'),
              ),
              ListTile(
                title: const Text('Default Camera Position'),
                trailing: Text('${settingData['camera']['x']}, '
                    '${settingData['camera']['y']}, '
                    '${settingData['camera']['z']}'),
              ),
              ListTile(
                title: const Text('Default Camera Target'),
                trailing: Text('${settingData['camera']['focusX']}, '
                    '${settingData['camera']['focusY']}, '
                    '${settingData['camera']['focusZ']}'),
              ),
            ],
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
    // IMPORTANT: Before updating the texture, it must be called to ensure that the gl program is executed.
    gl.flush();
    // var pixels = _gl.readCurrentPixels(0, 0, 10, 10);
    // print(' --------------pixels............. ');
    // print(pixels);
    if (verbose) {
      if (kDebugMode) {
        print(' render: sourceTexture: $sourceTexture ');
      }
    }
    var cameraPosition = camera.position;
    var cameraTarget = controls.target;
    setState(() {
      _fps = (1000 / (t1 - t)) ~/ 1;
      _cameraPosition = cameraPosition;
      _cameraTarget = cameraTarget;
    });
  }

  dynamic searchRecommend(String arg, bool editcomplete) {
    if (RegExp(
            r'[\u3105-\u3129]|\u02CA|\u02C7|\u02CB|\u02D9')
        .hasMatch(arg)) {
      return 'NA';
    }
    var result = <String>[];
    if (arg == '') {
      return 'NA';
    }
    for (var i in settingData['object']['set'].keys) {
      if (settingData['object']['set'][i]['name'] == null) {
        continue;
      }
      if (settingData['object']['set'][i]['searchable'] == false) {
        continue;
      }
      // name search
      if (settingData['general']['search']['nameSearch'] &&
          settingData['object']['set'][i]['nameSearch'] != false) {
        if (settingData['object']['set'][i]['name']!
            .toLowerCase()
            .contains(arg.toLowerCase())) {
          result.add(settingData['object']['set'][i]['name']!);
          continue;
        }
      }
      // description search
      if (settingData['general']['search']['descriptionSearch'] &&
          settingData['object']['set'][i]['descriptionSearch'] != false) {
        if (settingData['object']['set'][i]['description'] != null &&
            settingData['object']['set'][i]['description']!
                .toLowerCase()
                .contains(arg.toLowerCase())) {
          result.add(settingData['object']['set'][i]['name']!);
          continue;
        }
      }
      // keyword search
      if (settingData['general']['search']['keywordSearch'] &&
          settingData['object']['set'][i]['keywordSearch'] != false) {
        if (settingData['object']['set'][i]['keyword'] != null) {
          for (var j in settingData['object']['set'][i]['keyword']!) {
            if (j.toLowerCase() == arg.toLowerCase()) {
              result.add(settingData['object']['set'][i]['name']!);
              continue;
            }
          }
        }
      }
    }
    if (result.isNotEmpty) {
      return result;
    } else if (editcomplete) {
      return 'NotFound';
    } else if (RegExp(r'[\u4E00-\u9FA5]').hasMatch(arg)) {
      return 'NA';
    } else {
      return 'NotFound';
    }
  }

  search(String arg) {
    if (arg == '') {
      return;
    }
    setState(() {
      _selectedLocation = dNameToName[arg]!;
      _selectedLocationName = arg;
    });
    return dNameToName[arg];
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
      if (settingData['object']['set'][i]['render'] == false) {
        continue;
      }
      dynamic geo;
      if (mapData[i]!['shape'] == 'ball') {
        geo = three.SphereGeometry(mapData[i]!['radius'], 32, 64);
      } else {
        geo = three.BoxGeometry(1, 1, 1);
        geo.translate(0, 0.5, 0);
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
      var mesh = three.Mesh(geo, material);
      if (mapData[i]!['shape'] == 'ball') {
      } else {
        mesh.scale.set(
            mapData[i]!['length'], mapData[i]!['height'], mapData[i]!['width']);
      }
      mesh.position.set(mapData[i]!['x'], mapData[i]!['y'], mapData[i]!['z']);
      mesh.castShadow = true;
      mesh.receiveShadow = true;
      if (mapData[i]!['rotate'] != null) {
        mesh.rotateX(mapData[i]!['rotate']!['x']);
        mesh.rotateY(mapData[i]!['rotate']!['y']);
        mesh.rotateZ(mapData[i]!['rotate']!['z']);
      }
      if (RegExp(r'.*_###.*').allMatches(i).isNotEmpty) {
        mesh.name = i.replaceAll(RegExp(r'_###.*'), '');
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
          ? objectX + settingData['camera']['focusIncreaseX']
          : objectX - settingData['camera']['focusIncreaseX'],
      objectY + (objectHeight / 2) + settingData['camera']['focusIncreaseY'],
      objectZ >= 0
          ? objectZ + settingData['camera']['focusIncreaseZ']
          : objectZ - settingData['camera']['focusIncreaseZ'],
    );
    _navigatorTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || disposed) {
        timer.cancel();
        return;
      }
      var cameraPosition = camera.position;
      var distance = cameraPosition.distanceTo(tarCameraPosition);
      if (distance < 1) {
        cameraPosition.set(
            tarCameraPosition.x, tarCameraPosition.y, tarCameraPosition.z);
        timer.cancel();
        controls.autoRotate = settingData['controls']['autoRotate'];
        return;
      } else {
        cameraPosition.lerp(
            tarCameraPosition, settingData['camera']['focusLerp']);
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
          i.material = three.MeshPhysicalMaterial({
            'color': settingData['buildings']['focusColor'],
            'flatShading': true,
            'opacity': 1,
            'roughness': 0.1,
            'metalness': 0.1,
            'transparent': false,
          });
        } else {
          i.material = three.MeshPhysicalMaterial({
            'color': settingData['object']['set'][i.name]!['color'] ??
                settingData['buildings']['color'],
            'flatShading': true,
            'opacity': settingData['buildings']['focusOpacity'],
            'roughness': 0.1,
            'metalness': 0.1,
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
        cameraPosition.set(
            tarCameraPosition.x, tarCameraPosition.y, tarCameraPosition.z);
        timer.cancel();
        controls.autoRotate = settingData['controls']['autoRotate'];
        return;
      } else {
        cameraPosition.lerp(
            tarCameraPosition, settingData['camera']['focusLerp']);
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
        i.material = three.MeshPhysicalMaterial({
          'color': settingData['buildings']['randomColor'] == true
              ? (three.Math.random() * 0xffffff).toInt()
              : settingData['object']['set'][i.name]!['color'] ??
                  settingData['buildings']['color'],
          'flatShading': false,
          'opacity': 1,
          'roughness': 0.1,
          'metalness': 0.1,
          'transparent': false,
        });
      }
    }
  }

  @override
  void dispose() {
    disposed = true;
    three3dRender.dispose();
    _navigatorTimer?.cancel();
    _windowSizeTimer?.cancel();

    super.dispose();
  }
}
