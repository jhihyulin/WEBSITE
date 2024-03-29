import 'dart:async';

import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three3d/math/vector3.dart';
import 'package:three_dart/three3d/three.dart' as three_dart;
import 'package:three_dart/three_dart.dart' as three;
import 'package:three_dart_jsm/three_dart_jsm.dart' as three_jsm;

import '../widget/linear_progress_indicator.dart';
import '../widget/launch_url.dart';
import '../widget/card.dart';
import '../widget/text_field.dart';

const int deskopModeWidth = 640;

const Map settingData = {
  'version': {'name': 'Ver2023.6.27'},
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
    },
    'position': {
      // default
      'gateSlideDoor': 7, // open0 close10
    }
  },
  'camera': {
    'x': -35,
    'y': 5,
    'z': 90,
    'focusX': -10,
    'focusY': 0,
    'focusZ': 60,
    'focusIncreaseX': 25,
    'focusIncreaseY': 25,
    'focusIncreaseZ': 25,
    'focusLerp': 0.25,
  },
  'controls': {
    'enabled': true,
    'autoRotate': false,
    'autoRotateSpeed': 2.0,
    'searchFocus': true,
    'minPolarAngle': 1,
    'maxPolarAngle': 89,
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
      'position': {'x': -90, 'y': 40, 'z': 70},
      'target': {'x': 0, 'y': 0, 'z': 0},
      'shadow': {
        'enabled': true,
        'bias': -0.0006,
        'mapSize': {'width': 16384, 'height': 16384},
        'camera': {
          'left': -200,
          'right': 200,
          'top': 200,
          'bottom': -200,
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
      'build9': '教師宿舍',
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
      'build1_base': {'name': '行政大樓-基座', 'searchable': false},
      'build1_base_###1': {'name': '行政大樓-基座2', 'searchable': false},
      'build1_base_###2': {'name': '行政大樓-基座3', 'searchable': false},
      'build1_base_###3': {'name': '行政大樓-基座4', 'searchable': false},
      'build_stair': {'name': '行政大樓==通達樓-樓梯', 'searchable': false},
      'build1_ramp': {'name': '行政大樓-斜坡', 'searchable': false},
      'build1_colunm': {'name': '行政大樓-柱子1', 'searchable': false},
      'build1_colunm_###1': {'name': '行政大樓-柱子2', 'searchable': false},
      'build1_colunm_###2': {'name': '行政大樓-柱子3', 'searchable': false},
      'build1_colunm_###3': {'name': '行政大樓-柱子4', 'searchable': false},
      'build1_colunm_###4': {'name': '行政大樓-柱子5', 'searchable': false},
      'build1_colunm_###5': {'name': '行政大樓-柱子6', 'searchable': false},
      'build1_beam': {'name': '行政大樓-梁1', 'searchable': false},
      'build1_beam_###1': {'name': '行政大樓-梁2', 'searchable': false},
      'build1_beam_###2': {'name': '行政大樓-梁3', 'searchable': false},
      'build1_beam_###3': {'name': '行政大樓-梁4', 'searchable': false},
      'build1_beam_###4': {'name': '行政大樓-梁5', 'searchable': false},
      'build1_beam_###5': {'name': '行政大樓-梁6', 'searchable': false},
      'build1_beam_###6': {'name': '行政大樓-梁7', 'searchable': false},
      'build1_beam_###7': {'name': '行政大樓-梁8', 'searchable': false},
      'build1_beam_###8': {'name': '行政大樓-梁9', 'searchable': false},
      'build1_beam_###9': {'name': '行政大樓-梁10', 'searchable': false},
      'build1_beam_###10': {'name': '行政大樓-梁11', 'searchable': false},
      'build1_beam_###11': {'name': '行政大樓-梁12', 'searchable': false},
      'build1_beam_###12': {'name': '行政大樓-梁13', 'searchable': false},
      'build1_beam_###13': {'name': '行政大樓-梁14', 'searchable': false},
      'build1_beam_###14': {'name': '行政大樓-梁15', 'searchable': false},
      'build1_stairgate': {'name': '行政大樓-門前樓梯', 'searchable': false},
      'build1_stairgate_###1': {'name': '行政大樓-門前樓梯2', 'searchable': false},
      'build1_stairgate_###2': {'name': '行政大樓-門前樓梯3', 'searchable': false},
      'build1_stairgate_###3': {'name': '行政大樓-門前樓梯4', 'searchable': false},
      'build1_facade': {'name': '行政大樓-牆1', 'searchable': false},
      'build1_facade_###1': {'name': '行政大樓-牆2', 'searchable': false},
      'build1_facade_###2': {'name': '行政大樓-牆3', 'searchable': false},
      'build1_facade_###3': {'name': '行政大樓-牆4', 'searchable': false},
      'build1_facade_###4': {'name': '行政大樓-牆5', 'searchable': false},
      'build1_gate': {'name': '行政大樓-大門', 'searchable': false},
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
          '教官室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/military',
        },
        'keyword': [
          '訓育組',
          '訓育',
          '社團活動組',
          '社團活動',
          '社團',
          '衛生組',
          '衛生',
          '生輔組',
          '生輔',
          '教官'
        ],
      },
      'build1_1f_room2': {
        'name': '健康中心',
        'keyword': ['保健室']
      },
      'build1_1f_room2_###1': {'name': '健康中心#1', 'searchable': false},
      'build1_1f_facility1': {
        'name': 'ATM自動櫃員機',
        'description': '中華郵政',
        'keyword': ['中華郵政', '郵局', '提款機'],
      },
      'build1_2f_room1': {
        'name': '教務處',
        'description': '教學組、註冊組、試務組、實研組',
        'keyword': ['教學組', '教學', '註冊組', '註冊', '試務組', '試務', '實研組', '實研'],
        'link': {
          '教務處網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/teacheraffairs',
        }
      },
      'build1_2f_room2': {
        'name': '輔導處',
        'link': {
          '輔導處網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/consultation',
        }
      },
      'build1_3f_room1': {
        'name': '總務處 / 人事室',
        'description': '文書組、事務組、出納組',
        'keyword': ['文書組', '文書', '事務組', '事務', '出納組', '出納'],
        'link': {
          '總務處網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/generalaffairs',
          '人事室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/personnel',
        }
      },
      'build1_3f_room2': {
        'name': '校長室 / 秘書室',
        'link': {
          '校長室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/principal',
        }
      },
      'build1_3f_extend': {'name': '行政大樓3f露臺', 'searchable': false},
      'build1_3f_room3': {
        'name': '會計室',
        'link': {
          '會計室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/acc',
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
      'build1_stair1': {'name': '行政大樓樓梯1', 'searchable': false},
      'build1_stair1_###1': {'name': '行政大樓樓梯1-1', 'searchable': false},
      'build1_stair1_###2': {'name': '行政大樓樓梯1-2', 'searchable': false},
      'build1_stair1_###3': {'name': '行政大樓樓梯1-3', 'searchable': false},
      'build1_elevator': {'name': '行政大樓電梯', 'searchable': false},
      'build2_base1': {'name': '通達樓基1', 'searchable': false},
      'build2_1f_room1': {'name': '中型會議室'},
      'build2_2f_room1': {'name': '生物實驗室1'},
      'build2_3f_room1': {'name': '化學實驗室1'},
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
      'build3_b1_room1': {'name': '水餃店'},
      'build3_b1_room2': {'name': '麵店'},
      'build3_b1_room3': {'name': '自助餐'},
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
          '教官室網站': 'https://sites.google.com/mail2.chshs.ntpc.edu.tw/military',
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
        'keyword': ['天文', '天文館', '天文臺', '天文台', '望遠鏡']
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
        'link': {
          '圖書館網站':
              'https://sites.google.com/mail2.chshs.ntpc.edu.tw/library/%E9%A6%96%E9%A0%81',
        }
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
      'build7_build_###base1': {'name': '活動中心基1', 'searchable': false},
      'build7_build_###base2': {'name': '活動中心基2', 'searchable': false},
      'build7_toilet1': {'name': '活動中心女廁所', 'searchable': false},
      'build7_toilet2': {'name': '活動中心男廁所', 'searchable': false},
      'build7_build': {
        'name': '活動中心',
        'description': '籃球場、羽球場',
        'keyword': ['籃球場', '羽球場', '籃球', '羽球']
      },
      'build7_build_###build_extend1': {'name': '活動中心#1', 'searchable': false},
      'build7_build_###colunm_1': {'name': '活動中心柱子#1', 'searchable': false},
      'build7_build_###colunm_2': {'name': '活動中心柱子#2', 'searchable': false},
      'build7_build_###colunm_3': {'name': '活動中心柱子#3', 'searchable': false},
      'build7_build_###colunm_4': {'name': '活動中心柱子#4', 'searchable': false},
      'build7_build_###colunm_5': {'name': '活動中心柱子#5', 'searchable': false},
      'build7_build_###colunm_6': {'name': '活動中心柱子#6', 'searchable': false},
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
      'facility_gate_slidedoor': {'name': '大門滑門', 'searchable': false},
      'facility_gate_slidedoor_###1': {'name': '大門滑門#1', 'searchable': false},
      'facility_gate_slidedoor_###c1': {'name': '大門滑門#c1', 'searchable': false},
      'facility_gate_slidedoor_###c2': {'name': '大門滑門#c2', 'searchable': false},
      'facility_gate_slidedoor_###c3': {'name': '大門滑門#c3', 'searchable': false},
      'facility_gate_slidedoor_###c4': {'name': '大門滑門#c4', 'searchable': false},
      'facility_gate_slidedoor_###c5': {'name': '大門滑門#c5', 'searchable': false},
      'facility_gate_slidedoor_###c6': {'name': '大門滑門#c6', 'searchable': false},
      'facility_gate_slidedoor_###c7': {'name': '大門滑門#c7', 'searchable': false},
      'facility_gate_slidedoor_###c8': {'name': '大門滑門#c8', 'searchable': false},
      'facility_gate_slidedoor_###c9': {'name': '大門滑門#c9', 'searchable': false},
      'facility_gate_slidedoor_###c10': {
        'name': '大門滑門#c10',
        'searchable': false
      },
      'facility_court1': {'name': '籃球場B'},
      'facility_court2': {'name': '排球場'},
      'facility_court3': {'name': '籃球場A'},
      'facility_court4': {'name': '未知用途球場'},
      'facility_court4_###1': {'name': '未知用途球場#1', 'searchable': false},
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
              'https://web.pcc.gov.tw/tps/atm/AtmAwardWithoutSso/QueryAtmAwardDetail?pkAtmMain=MjM1NzU4',
        }
      },
      'facility_electronic1': {'name': '電箱'},
      'facility_electronic1_###1': {'name': '電箱#1', 'searchable': false},
      'facility_garbages1': {'name': '垃圾場 / 廚餘'},
      'facility_electronic2': {'name': '變電所'},
      'facility_platform1': {'name': '司令台'},
      'facility_ground1': {'name': '運動場'},
      'facility_ground1_###1': {'name': '運動場#1', 'searchable': false},
      'facility_parkingLot2': {'name': '停車場#1', 'render': false},
      'facility_parkingLot3': {'name': '停車場#2', 'render': false},
      'wall': {'name': '校園圍牆'},
      'wall_###1': {'name': '校園圍牆#1', 'searchable': false},
      'wall_###2': {'name': '校園圍牆#2', 'searchable': false},
      'wall_###3': {'name': '校園圍牆#3', 'searchable': false},
      'wall_###4': {'name': '校園圍牆#4', 'searchable': false},
      'wall_###5': {'name': '校園圍牆#5', 'searchable': false},
      'wall_###6': {'name': '校園圍牆#6', 'searchable': false},
      'wall_###7': {'name': '校園圍牆#7', 'searchable': false},
      'wall_###8': {'name': '校園圍牆#8', 'searchable': false},
      'wall_###9': {'name': '校園圍牆#9', 'searchable': false},
      'wall_###10': {'name': '校園圍牆#10', 'searchable': false},
      'wall_###11': {'name': '校園圍牆#11', 'searchable': false},
      'wall_###12': {'name': '校園圍牆#12', 'searchable': false},
      'wall_###13': {'name': '校園圍牆#13', 'searchable': false},
      'hill': {'name': '後山', 'searchable': false},
      'hill_###1': {'name': '後山#1', 'searchable': false},
      'hill_###2': {'name': '後山#2', 'searchable': false},
      'hill_###3': {'name': '後山#3', 'searchable': false},
      'hill_###4': {'name': '後山#4', 'searchable': false},
    }
  },
  'ground': {'color': 0x96ad82, 'width': 5000, 'length': 5000},
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
  'build1_base': {
    'build': 'build1',
    'x': -12,
    'y': 0,
    'z': 52.5,
    'height': 1,
    'width': 15,
    'length': 5
  },
  'build1_base_###1': {
    'build': 'build1',
    'x': -10.5,
    'y': 0,
    'z': 67, //60
    'height': 1,
    'width': 14,
    'length': 2
  },
  'build1_base_###2': {
    'build': 'build1',
    'x': -14.1,
    'y': 0,
    'z': 67.5,
    'height': 1,
    'width': 15,
    'length': 0.8
  },
  'build1_base_###3': {
    'build': 'build1',
    'x': -11.6,
    'y': 0,
    'z': 67.5,
    'height': 2,
    'width': 15,
    'length': 0.2
  },
  'build1_stair': {
    'build': 'build1',
    'x': -10,
    'y': 0,
    'z': 42.5,
    'height': 29,
    'width': 5,
    'length': 9
  },
  'build1_stair1': {
    'build': 'build1',
    'x': -10.5,
    'y': 0,
    'z': 74.4,
    'height': 0.2,
    'width': 0.8,
    'length': 2
  },
  'build1_stair1_###1': {
    'build': 'build1',
    'x': -10.5,
    'y': 0.2,
    'z': 74.3,
    'height': 0.2,
    'width': 0.6,
    'length': 2
  },
  'build1_stair1_###2': {
    'build': 'build1',
    'x': -10.5,
    'y': 0.4,
    'z': 74.2,
    'height': 0.2,
    'width': 0.4,
    'length': 2
  },
  'build1_stair1_###3': {
    'build': 'build1',
    'x': -10.5,
    'y': 0.6,
    'z': 74.1,
    'height': 0.2,
    'width': 0.2,
    'length': 2
  },
  'build1_ramp': {
    'build': 'build1',
    'x': -12.7,
    'y': -0.5,
    'z': 67.5,
    'height': 1,
    'width': 15.18,
    'length': 2,
    'rotate': {'x': 0.0664, 'y': 0, 'z': 0}
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
  'build1_colunm': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 74.6,
    'height': 10,
    'width': 0.8,
    'length': 0.8
  },
  'build1_colunm_###1': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 69.7,
    'height': 10,
    'width': 0.8,
    'length': 0.8
  },
  'build1_colunm_###2': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 64.8,
    'height': 7,
    'width': 0.8,
    'length': 0.8
  },
  'build1_colunm_###3': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 59.9,
    'height': 7,
    'width': 0.8,
    'length': 0.8
  },
  'build1_colunm_###4': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 55,
    'height': 7,
    'width': 0.8,
    'length': 0.8
  },
  'build1_colunm_###5': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 50.1,
    'height': 7,
    'width': 0.8,
    'length': 0.8
  },
  'build1_beam': {
    'build': 'build1',
    'x': -11.6,
    'y': 5,
    'z': 74.6,
    'height': 0.5,
    'width': 0.5,
    'length': 4.2
  },
  'build1_beam_###1': {
    'build': 'build1',
    'x': -14.1,
    'y': 5,
    'z': 72.15,
    'height': 0.5,
    'width': 4.1,
    'length': 0.5
  },
  'build1_beam_###2': {
    'build': 'build1',
    'x': -14.1,
    'y': 5,
    'z': 67.25,
    'height': 0.5,
    'width': 4.1,
    'length': 0.5
  },
  'build1_beam_###3': {
    'build': 'build1',
    'x': -14.1,
    'y': 5,
    'z': 62.35,
    'height': 0.5,
    'width': 4.1,
    'length': 0.5
  },
  'build1_beam_###4': {
    'build': 'build1',
    'x': -14.1,
    'y': 5,
    'z': 57.45,
    'height': 0.5,
    'width': 4.1,
    'length': 0.5
  },
  'build1_beam_###5': {
    'build': 'build1',
    'x': -14.1,
    'y': 5,
    'z': 52.55,
    'height': 0.5,
    'width': 4.1,
    'length': 0.5
  },
  'build1_beam_###6': {
    'build': 'build1',
    'x': -14.1,
    'y': 5,
    'z': 47.35,
    'height': 0.5,
    'width': 4.7,
    'length': 0.5
  },
  'build1_beam_###7': {
    'build': 'build1',
    'x': -11.6,
    'y': 7,
    'z': 74.6,
    'height': 2,
    'width': 0.5,
    'length': 4.2
  },
  'build1_beam_###8': {
    'build': 'build1',
    'x': -14.1,
    'y': 7,
    'z': 72.15,
    'height': 2,
    'width': 4.1,
    'length': 0.5
  },
  'build1_beam_###9': {
    'build': 'build1',
    'x': -14.1,
    'y': 7,
    'z': 67.25,
    'height': 2,
    'width': 4.1,
    'length': 0.5
  },
  'build1_beam_###10': {
    'build': 'build1',
    'x': -11.6,
    'y': 5,
    'z': 69.7,
    'height': 0.5,
    'width': 0.5,
    'length': 4.2
  },
  'build1_beam_###11': {
    'build': 'build1',
    'x': -11.6,
    'y': 5,
    'z': 64.8,
    'height': 0.5,
    'width': 0.5,
    'length': 4.2
  },
  'build1_beam_###12': {
    'build': 'build1',
    'x': -11.6,
    'y': 5,
    'z': 59.9,
    'height': 0.5,
    'width': 0.5,
    'length': 4.2
  },
  'build1_beam_###13': {
    'build': 'build1',
    'x': -11.6,
    'y': 5,
    'z': 55,
    'height': 0.5,
    'width': 0.5,
    'length': 4.2
  },
  'build1_beam_###14': {
    'build': 'build1',
    'x': -11.6,
    'y': 5,
    'z': 50.1,
    'height': 0.5,
    'width': 0.5,
    'length': 4.2
  },
  'build1_stairgate': {
    'build': 'build1',
    'x': -14.9,
    'y': 0,
    'z': 55,
    'height': 0.2,
    'width': 9.8,
    'length': 0.8
  },
  'build1_stairgate_###1': {
    'build': 'build1',
    'x': -14.8,
    'y': 0.2,
    'z': 55,
    'height': 0.2,
    'width': 9.8,
    'length': 0.6
  },
  'build1_stairgate_###2': {
    'build': 'build1',
    'x': -14.7,
    'y': 0.4,
    'z': 55,
    'height': 0.2,
    'width': 9.8,
    'length': 0.4
  },
  'build1_stairgate_###3': {
    'build': 'build1',
    'x': -14.6,
    'y': 0.6,
    'z': 55,
    'height': 0.2,
    'width': 9.8,
    'length': 0.2
  },
  'build1_facade': {
    'build': 'build1',
    'x': -9.25,
    'y': 1,
    'z': 47,
    'height': 7,
    'width': 4,
    'length': 0.5
  },
  'build1_facade_###1': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 72.15,
    'height': 0.7,
    'width': 4.1,
    'length': 0.5
  },
  'build1_facade_###2': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 67.25,
    'height': 0.7,
    'width': 4.1,
    'length': 0.5
  },
  'build1_facade_###3': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 62.35,
    'height': 0.7,
    'width': 4.1,
    'length': 0.5
  },
  'build1_facade_###4': {
    'build': 'build1',
    'x': -14.1,
    'y': 1,
    'z': 47.35,
    'height': 0.7,
    'width': 4.7,
    'length': 0.5
  },
  'build1_gate': {
    'build': 'build1',
    'x': -9.25,
    'y': 1,
    'z': 54.5,
    'height': 4,
    'width': 11,
    'length': 0.5,
    'opacity': 0.2
  },
  // build1_b1
  'build1_b1_room1': {
    'build': 'build1',
    'x': 0.5,
    'y': -2,
    'z': 60,
    'height': 3,
    'width': 30,
    'length': 20,
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
  'build1_1f_room2_###1': {
    'build': 'build1',
    'x': 9.5,
    'y': 1,
    'z': 57,
    'height': 4,
    'width': 6,
    'length': 2,
    'floor': 1,
  },
  'build1_1f_facility1': {
    'build': 'build1',
    'x': 9.5,
    'y': 1,
    'z': 52.5,
    'height': 4,
    'width': 3,
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
    'z': 57.1,
    'height': 3,
    'width': 16.2,
    'length': 5,
    'floor': 3,
  },
  'build1_3f_extend': {
    'x': -15.25,
    'y': 8,
    'z': 55,
    'height': 1.5,
    'width': 14,
    'length': 1.5
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
  'build7_build_###base1': {
    'build': 'build7',
    'x': -75,
    'y': 0,
    'z': 60,
    'height': 1,
    'width': 50,
    'length': 35
  },
  'build7_build_###base2': {
    'build': 'build7',
    'x': -55,
    'y': 0,
    'z': 60,
    'height': 1,
    'width': 37,
    'length': 5
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
  'build7_build_###build_extend1': {
    'build': 'build7',
    'x': -55,
    'y': 10,
    'z': 60,
    'height': 1,
    'width': 28,
    'length': 5
  },
  'build7_build_###colunm_1': {
    'build': 'build7',
    'x': -53.5,
    'y': 1,
    'z': 72, // 60
    'height': 10,
    'width': 1,
    'length': 1
  },
  'build7_build_###colunm_2': {
    'build': 'build7',
    'x': -53.5,
    'y': 1,
    'z': 67,
    'height': 10,
    'width': 1,
    'length': 1
  },
  'build7_build_###colunm_3': {
    'build': 'build7',
    'x': -53.5,
    'y': 1,
    'z': 62,
    'height': 10,
    'width': 1,
    'length': 1
  },
  'build7_build_###colunm_4': {
    'build': 'build7',
    'x': -53.5,
    'y': 1,
    'z': 58,
    'height': 10,
    'width': 1,
    'length': 1
  },
  'build7_build_###colunm_5': {
    'build': 'build7',
    'x': -53.5,
    'y': 1,
    'z': 53,
    'height': 10,
    'width': 1,
    'length': 1
  },
  'build7_build_###colunm_6': {
    'build': 'build7',
    'x': -53.5,
    'y': 1,
    'z': 48,
    'height': 10,
    'width': 1,
    'length': 1
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
  'facility_gate_slidedoor': {
    'x': -20, //-30close -20open
    'y': 0,
    'z': 102,
    'height': 0.4,
    'width': 0.3,
    'length': 10,
  },
  'facility_gate_slidedoor_###1': {
    'x': -20, //-30close -20open
    'y': 1.6,
    'z': 102,
    'height': 0.4,
    'width': 0.3,
    'length': 10,
  },
  'facility_gate_slidedoor_###c1': {
    'x': -24.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c2': {
    'x': -23.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c3': {
    'x': -22.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c4': {
    'x': -21.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c5': {
    'x': -20.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c6': {
    'x': -19.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c7': {
    'x': -18.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c8': {
    'x': -17.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c9': {
    'x': -16.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
  },
  'facility_gate_slidedoor_###c10': {
    'x': -15.75,
    'y': 0.4,
    'z': 102,
    'height': 1.2,
    'width': 0.3,
    'length': 0.5,
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
  'facility_court4_###1': {
    'x': -65.4,
    'y': 0,
    'z': -87.95,
    'height': 3,
    'width': 15,
    'length': 0.3,
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
    'height': 4,
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
    'x': 28,
    'y': 0,
    'z': 98.5,
    'height': 2,
    'width': 3,
    'length': 7
  },
  'facility_electronic1_###1': {
    'x': 23,
    'y': 0,
    'z': 99,
    'height': 3,
    'width': 2,
    'length': 3
  },
  'facility_garbages1': {
    'x': 37,
    'y': 0,
    'z': 98.5,
    'height': 2,
    'width': 3,
    'length': 11,
    'rotate': {'x': 0, 'y': -0.05, 'z': 0}
  },
  'facility_electronic2': {
    'x': 74,
    'y': 0,
    'z': -2,
    'height': 4,
    'width': 13,
    'length': 8,
    'rotate': {'x': 0, 'y': -0.6, 'z': 0}
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
  'facility_ground1_###1': {
    'x': 55,
    'y': 0,
    'z': -125,
    'height': 0.1,
    'width': 10,
    'length': 15
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
  'wall': {'x': -13.5, 'y': 0, 'z': 102, 'height': 4, 'width': 1, 'length': 15},
  'wall_###1': {
    'x': 7.75,
    'y': 0,
    'z': 100.5,
    'height': 2,
    'width': 0.3,
    'length': 28,
    'rotate': {'x': 0, 'y': 0.1, 'z': 0}
  },
  'wall_###2': {
    'x': -51.5,
    'y': 0,
    'z': 103.5,
    'height': 4,
    'width': 0.3,
    'length': 6,
    'rotate': {'x': 0, 'y': 0.5, 'z': 0}
  },
  'wall_###3': {
    'x': -74,
    'y': 0,
    'z': 106,
    'height': 2,
    'width': 0.3,
    'length': 40,
    'rotate': {'x': 0, 'y': 0.05, 'z': 0}
  },
  'wall_###4': {
    'x': -98,
    'y': 0,
    'z': 79.95,
    'height': 2,
    'width': 55,
    'length': 0.3,
    'rotate': {'x': 0, 'y': 0.15, 'z': 0}
  },
  'wall_###5': {
    'x': -93.6,
    'y': 0,
    'z': 35.2,
    'height': 2,
    'width': 39.2,
    'length': 0.3,
    'rotate': {'x': 0, 'y': -0.45, 'z': 0}
  },
  'wall_###6': {
    'x': -85.15,
    'y': 0,
    'z': 0,
    'height': 2,
    'width': 35,
    'length': 0.3
  },
  'wall_###7': {
    'x': 55,
    'y': 0,
    'z': 57,
    'height': 2,
    'width': 85,
    'length': 0.3,
    'rotate': {'x': 0, 'y': -0.3, 'z': 0}
  },
  'wall_###8': {
    'x': 81.5,
    'y': 0,
    'z': -4,
    'height': 2,
    'width': 50,
    'length': 0.3,
    'rotate': {'x': 0, 'y': -0.6, 'z': 0}
  },
  'wall_###9': {
    'x': 100.5,
    'y': 0,
    'z': -49,
    'height': 2,
    'width': 50,
    'length': 0.3,
    'rotate': {'x': 0, 'y': -0.2, 'z': 0}
  },
  'wall_###10': {
    'x': 103,
    'y': 0,
    'z': -81.5,
    'height': 2,
    'width': 17,
    'length': 0.3,
    'rotate': {'x': 0, 'y': 0.3, 'z': 0}
  },
  'wall_###11': {
    'x': 95,
    'y': 0,
    'z': -97.5,
    'height': 2,
    'width': 20,
    'length': 0.3,
    'rotate': {'x': 0, 'y': 0.6, 'z': 0}
  },
  'wall_###12': {
    'x': 76.5,
    'y': 0,
    'z': -113,
    'height': 2,
    'width': 0.3,
    'length': 30,
    'rotate': {'x': 0, 'y': -0.52, 'z': 0}
  },
  'wall_###13': {
    'x': 63.5,
    'y': 0,
    'z': -129.85,
    'height': 2,
    'width': 19,
    'length': 0.3
  },
  'hill': {
    'x': 0,
    'y': -15,
    'z': -162,
    'height': 30,
    'width': 30,
    'length': 190,
    'rotate': {'x': 0.7, 'y': 0, 'z': 0}
  },
  'hill_###1': {
    'x': 93,
    'y': -31,
    'z': -134,
    'height': 40,
    'width': 40,
    'length': 40,
    'rotate': {'x': 0.5, 'y': 0.65, 'z': 0.5}
  },
  'hill_###2': {
    'x': 90,
    'y': -18,
    'z': -138,
    'height': 30,
    'width': 30,
    'length': 30,
    'rotate': {'x': -0.2, 'y': 0.2, 'z': 0.7}
  },
  'hill_###3': {
    'x': -93.7,
    'y': -26,
    'z': -73,
    'height': 40,
    'width': 180,
    'length': 40,
    'rotate': {'x': 0, 'y': 0, 'z': 0.5}
  },
  'hill_###4': {
    'x': -75,
    'y': -30,
    'z': -105,
    'height': 40,
    'width': 110,
    'length': 40,
    'rotate': {'x': 0, 'y': -0.5, 'z': 0.4}
  },
};

class ZHSH3DMapPage extends StatefulWidget {
  const ZHSH3DMapPage({
    Key? key,
    this.embededMode = false,
  }) : super(key: key);

  final bool embededMode;

  @override
  State<ZHSH3DMapPage> createState() => _ZHSH3DMapPageState();
}

class _ZHSH3DMapPageState extends State<ZHSH3DMapPage>
    with TickerProviderStateMixin<ZHSH3DMapPage> {
  Map<String, String> dNameToName = {};
  Map<String, String> nameToDName = {};

  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;

  final bool _lightHelper = kDebugMode;
  final bool _groundHelper = false;

  bool _embededMode = false;

  Timer? _navigatorTimer;
  Timer? _devModeTimer;
  Timer? _windowSizeTimer;
  Timer? _initTimer;

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
  bool _initialized = false;

  late three.WebGLRenderTarget renderTarget;

  dynamic sourceTexture;

  final GlobalKey<three_jsm.DomLikeListenableState> _globalKey =
      GlobalKey<three_jsm.DomLikeListenableState>();
  AnimationController? _hideFabAnimation;
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation?.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation?.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  late three_jsm.OrbitControls controls;

  bool _devMode = false;
  bool _fullScreen = false;

  double _gateSlideDoor =
      settingData['general']['position']['gateSlideDoor'] ?? 0;

  int _fps = 0;

  String _notFoundText = '找不到地點';
  bool _notFound = false;

  final TextEditingController _searchController = TextEditingController();
  List _searchResult = [];
  bool _searchSelected = false;

  Vector3 _cameraPosition = Vector3(0, 0, 0);
  Vector3 _cameraTarget = Vector3(0, 0, 0);

  @override
  void initState() {
    _embededMode = widget.embededMode;
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation?.forward();
    _windowSizeTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (screenSize != MediaQuery.of(context).size) {
        if (MediaQuery.of(context).size.width > deskopModeWidth) {
          width = MediaQuery.of(context).size.width / 3 * 2;
          height = MediaQuery.of(context).size.height -
              (_fullScreen || _embededMode ? 0 : AppBar().preferredSize.height);
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
          (_fullScreen || _embededMode ? 0 : AppBar().preferredSize.height);
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
      appBar: _fullScreen || _embededMode
          ? null
          : AppBar(
              title: const Text('中和高中3D校園地圖'),
            ),
      body: Stack(
        children: [
          Offstage(
            offstage: _initialized,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxWidth: 700,
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomLinearProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: _initialized == false,
            child: MediaQuery.of(context).size.width > deskopModeWidth
                ? _buildDesktop(context)
                : _buildMobile(context),
          ),
        ],
      ),
      floatingActionButton: _initialized
          ? ScaleTransition(
              scale: _hideFabAnimation!,
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () {
                  _navigatorTimer?.cancel();
                  resetCamera();
                  resetLayout();
                  resetBuilgingColor();
                },
                tooltip: '重設地點',
                child: const Icon(Icons.home),
              ),
            )
          : null,
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
              child: HtmlElementView(
                viewType: three3dRender.textureId!.toString(),
              ),
            );
          },
        ),
        NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: const EdgeInsets.all(16.0),
              child: _contentWidget(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GestureDetector(
              onVerticalDragStart: (_) {},
              child: three_jsm.DomLikeListenable(
                key: _globalKey,
                builder: (BuildContext context) {
                  return SizedBox(
                    width: width,
                    height: height,
                    child: Builder(
                      builder: (BuildContext context) {
                        return HtmlElementView(
                          viewType: three3dRender.textureId!.toString(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              child: _contentWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentWidget() {
    return Column(
      children: [
        CustomCard(
          // do not cut label text
          clipBehavior: Clip.none,
          child: Column(
            children: [
              CustomTextField(
                controller: _searchController,
                onChanged: (String value) {
                  if (_notFound && value.isNotEmpty) {
                    setState(() {
                      _notFound = false;
                    });
                  }
                },
                onSubmitted: (String value) {
                  if (value.isEmpty) {
                    return;
                  }
                  var search = searchRecommend(value);
                  if (search == 'NotFound') {
                    setState(() {
                      _notFound = true;
                      _notFoundText = '找不到地點';
                    });
                  } else if (search == 'Empty') {
                    setState(() {
                      _notFound = true;
                      _notFoundText = '請輸入關鍵字';
                    });
                  } else {
                    setState(() {
                      _notFound = false;
                    });
                  }
                  onFieldSubmitted(search);
                },
                keyboardType: TextInputType.text,
                onEditingComplete: () {
                  onFieldSubmitted(_searchController.text);
                },
                labelText: '搜尋地點',
                hintText: '請輸入關鍵字',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    onFieldSubmitted(_searchController.text);
                  },
                ),
                errorText: _notFound ? _notFoundText : null,
              ),
              Text(
                'ALL RIGHTS RESERVED © ${DateTime.now().year} JHIHYULIN.LIVE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                ),
              ),
            ],
          ),
        ),
        CustomCard(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Offstage(
                offstage: _searchSelected == true || _searchResult.isEmpty,
                child: const Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: null,
                    ),
                    title: Text('搜尋結果'),
                  ),
                ]),
              ),
              Offstage(
                offstage: _notFound == true || _searchSelected == true,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 3,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        if (_searchResult.isNotEmpty)
                          for (String i in _searchResult)
                            ListTile(
                              title: Text(i),
                              subtitle: settingData['object']['set']
                                          [dNameToName[i]]['description'] !=
                                      null
                                  ? Text(
                                      settingData['object']['set']
                                          [dNameToName[i]]['description'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              onTap: () {
                                if (kDebugMode) {
                                  print('You just selected Display Name: $i');
                                }
                                var id = search(i);
                                if (settingData['controls']['searchFocus'] ==
                                    true) {
                                  focus(id);
                                }
                                setState(() {
                                  _searchSelected = true;
                                });
                              },
                            ),
                      ],
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: _searchSelected == false,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              _searchSelected = false;
                            });
                            _navigatorTimer?.cancel();
                            resetCamera();
                            resetLayout();
                            resetBuilgingColor();
                          },
                        ),
                        title: const Text('返回'),
                      ),
                      Offstage(
                        offstage: _selectedLocation == '',
                        child: ListTile(
                          title: const Text('地點'),
                          subtitle: Text(_selectedLocationName),
                        ),
                      ),
                      Offstage(
                        offstage: _selectedLocation == '' ||
                            mapData[_selectedLocation]!['build'] == null ||
                            settingData['buildings']!['name']
                                    [mapData[_selectedLocation]!['build']] ==
                                null,
                        child: ListTile(
                          title: const Text('建築'),
                          subtitle: Text(
                              '${_selectedLocation == '' ? '' : settingData['buildings']!['name'][mapData[_selectedLocation]!['build']] ?? 'None'}'),
                        ),
                      ),
                      Offstage(
                        offstage: _selectedLocation == '' ||
                            mapData[_selectedLocation]!['floor'] == null,
                        child: ListTile(
                          title: const Text('樓層'),
                          subtitle: Text(
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
                        ),
                      ),
                      Offstage(
                        offstage: _selectedLocation == '' ||
                            settingData['object']['set'][_selectedLocation]
                                    ['link'] ==
                                null,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _selectedLocation == '' ||
                                    settingData['object']['set']
                                            [_selectedLocation]['link'] ==
                                        null
                                ? const []
                                : [
                                    for (var link in settingData['object']
                                            ['set'][_selectedLocation]['link']
                                        .keys)
                                      ElevatedButton(
                                        onPressed: settingData['object']['set']
                                                        [_selectedLocation]
                                                    ['link'][link]
                                                .isEmpty
                                            ? null
                                            : () {
                                                CustomLaunchUrl.launch(
                                                    context,
                                                    settingData['object']['set']
                                                            [_selectedLocation]
                                                        ['link'][link]);
                                              },
                                        child: Text(link),
                                      ),
                                  ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
              const Text('常按5秒開啟本選單'),
              const Text('輕觸一下關閉本選單'),
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
              ListTile(
                title: const Text('Gate Slide Door'),
                subtitle: Slider(
                  value: _gateSlideDoor,
                  min: 0,
                  max: 10,
                  divisions: null,
                  onChanged: (double value) {
                    setState(() {
                      _gateSlideDoor = value;
                    });
                    setGateSlideDoor(_gateSlideDoor);
                  },
                ),
              ),
              ListTile(
                title: const Text('嵌入模式'),
                subtitle: const Text(
                    'https://jhihyulin.live/zhsh3dmap?embededMode=true'),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    html.window.navigator.clipboard?.writeText(
                        'https://jhihyulin.live/zhsh3dmap?embededMode=true');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  void onFieldSubmitted(String value) {
    resetLayout();
    var search = searchRecommend(value);
    if (search == 'NotFound') {
      setState(() {
        _notFound = true;
        _notFoundText = '找不到地點';
        _searchResult = [];
        _searchSelected = false;
      });
    } else if (search == 'Empty') {
      setState(() {
        _notFound = true;
        _notFoundText = '請輸入關鍵字';
      });
    } else {
      setState(() {
        _notFound = false;
        _searchResult = search;
        _searchSelected = false;
      });
      debugPrint('searchResult: $_searchResult');
    }
  }

  void onSelected(String selection) {
    if (kDebugMode) {
      print('You just selected Display Name: $selection');
    }
    var id = search(selection);
    if (settingData['controls']['searchFocus'] == true) {
      focus(id);
    }
  }

  dynamic searchRecommend(String arg) {
    // if (RegExp(r'[\u3105-\u3129]|\u02CA|\u02C7|\u02CB|\u02D9').hasMatch(arg)) {
    //   return 'NA';
    // }
    var result = <String>[];
    if (arg == '') {
      return 'Empty';
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
    result.sort();
    if (result.isNotEmpty) {
      return result;
      // } else if (RegExp(r'[\u4E00-\u9FA5]').hasMatch(arg)) {
      //   return 'NA';
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
      'canvas': three3dRender.element,
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
    initObject();
    _initTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        _initialized = true;
      });
    });
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
    controls.minPolarAngle = settingData['controls']['minPolarAngle'] *
        three.Math.pi /
        180; // radians
    controls.maxPolarAngle = settingData['controls']['maxPolarAngle'] *
        three.Math.pi /
        180; // radians
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
      if (mapData[i]!['opacity'] != null) {
        mesh.material.opacity = mapData[i]!['opacity'];
        mesh.material.transparent = true;
      }
      mesh.position.set(mapData[i]!['x'], mapData[i]!['y'], mapData[i]!['z']);
      mesh.castShadow = true;
      mesh.receiveShadow = true;
      if (mapData[i]!['rotate'] != null) {
        mesh.rotateX(mapData[i]!['rotate']!['x']);
        mesh.rotateY(mapData[i]!['rotate']!['y']);
        mesh.rotateZ(mapData[i]!['rotate']!['z']);
      }
      // if (RegExp(r'.*_###.*').allMatches(i).isNotEmpty) {
      //   mesh.name = i.replaceAll(RegExp(r'_###.*'), '');
      // } else {
      mesh.name = i;
      // }
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
        if (i.name.replaceAll(RegExp(r'_###.*'), '') == buildingName) {
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
      _searchSelected = false;
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
          'opacity': mapData[i.name]!['opacity'] ?? 1,
          'roughness': 0.1,
          'metalness': 0.1,
          'transparent': mapData[i.name]!['opacity'] != null,
        });
      }
    }
  }

  initObject() {
    setGateSlideDoor(_gateSlideDoor);
  }

  setGateSlideDoor(double value) {
    var mesh = scene.getObjectByName('facility_gate_slidedoor') as three.Mesh;
    mesh.position.setX(mapData['facility_gate_slidedoor']!['x']! - value);
    if (kDebugMode) {
      print('setGateSlideDoor: $value');
    }
    var li = ['1', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9', 'c10'];
    for (var i in li) {
      var mesh =
          scene.getObjectByName('facility_gate_slidedoor_###$i') as three.Mesh;
      mesh.position
          .setX(mapData['facility_gate_slidedoor_###$i']!['x']! - value);
      if (kDebugMode) {
        print('setGateSlideDoor: $value, facility_gate_slidedoor_###$i');
      }
      mesh.updateMatrix();
    }
    mesh.updateMatrix();
  }

  @override
  void dispose() {
    disposed = true;
    three3dRender.dispose();
    _navigatorTimer?.cancel();
    _windowSizeTimer?.cancel();
    _hideFabAnimation?.dispose();
    _initTimer?.cancel();

    super.dispose();
  }
}
