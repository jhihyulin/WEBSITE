import 'dart:async';
import 'dart:html';

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
  "camera": {
    "x": 100,
    "y": 100,
    "z": 100,
    "focusX": 0,
    "focusY": 0,
    "focusZ": 0,
  },
  "controls": {"enabled": true, "autoRotate": false, "autoRotateSpeed": 2.0},
  "lights": [
    {
      "type": "ambient",
      "color": 0xffffff,
      "intensity": 0.5,
    },
    {
      "type": "directional",
      "color": 0xffffff,
      "intensity": 0.5,
      "position": {"x": 0, "y": 100, "z": 0},
      "target": {"x": 0, "y": 0, "z": 0},
      "shadow": {
        "enabled": true,
        "camera": {
          "left": -100,
          "right": 100,
          "top": 100,
          "bottom": -100,
          "near": 0.1,
          "far": 1000,
        },
        "mapSize": {"width": 1024, "height": 1024}
      }
    },
  ],
  "buildings": {
    "color": 0xaaaaaa,
    "focusColor": 0xff0000,
  },
  "ground": {
    "color": 0x96ad82,
    "width": 200,
    "length": 250,
  },
  "background": {
    "color": 'system', // 'system' or 0x000000
  },
};

// TODO: Load from web
// name, build, floor, x, y, z, height, width, length, type, description, color, render
const Map<String, Map<String, dynamic>> mapData = {
  'class1': {
    'name': 'class1name',
    'build': 'build1',
    'floor': 1,
    'x': 0,
    'y': 0,
    'z': 0,
    'height': 30,
    'width': 10,
    'length': 10,
    'type': 'class',
    'description': 'class 1 description',
    'color': 0x00ff00
  },
  'class2': {
    'name': 'class2name',
    'build': 'build2',
    'floor': 1,
    'x': 100,
    'y': 0,
    'z': 100,
    'height': 30,
    'width': 10,
    'length': 10,
    'type': 'class',
    'description': 'class 2 description',
    'color': 0x0000ff
  },
  'class3': {
    'name': 'class3name',
    'build': 'build3',
    'floor': 1,
    'x': -100,
    'y': 0,
    'z': -100,
    'height': 30,
    'width': 10,
    'length': 10,
    'type': 'class',
    'description': 'class 3 description'
  },
  'room#1': {
    'name': '中文測試名稱',
    'build': 'build1',
    'floor': 1,
    'x': 10,
    'y': 0,
    'z': 20,
    'height': 3,
    'width': 10,
    'length': 10,
    'type': 'room',
    'description': '中文測試描述'
  },
  'room#2': {
    'name': '二樓測試',
    'build': 'build1',
    'floor': 2,
    'x': 10,
    'y': 3,
    'z': 20,
    'height': 3,
    'width': 10,
    'length': 10,
    'type': 'room',
    'description': '二樓測試描述',
    'color': 0xff0000
  },
  'single#1': {
    'name': 'single#1name',
    'build': 'build1',
    'floor': 1,
    'x': 100,
    'y': 0,
    'z': 50,
    'height': 12,
    'width': 25,
    'length': 15,
    'type': 'single',
    'description': 'single#1 description'
  },
  'noRender#1': {
    'name': 'noRender#1name',
    'build': 'build3',
    'floor': 1,
    'x': -100,
    'y': 0,
    'z': 50,
    'height': 12,
    'width': 25,
    'length': 15,
    'type': 'single',
    'description': 'noRender#1 description',
    'render': false
  }
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
      "antialias": true,
      "alpha": false,
      "width": width.toInt(),
      "height": height.toInt(),
      "dpr": dpr
    };

    await three3dRender.initialize(options: options);

    setState(() {
      dNameToName = {for (var i in mapData.keys) mapData[i]!['name']: i};
      nameToDName = {for (var i in mapData.keys) i: mapData[i]!['name']};
    });

    Future.delayed(const Duration(milliseconds: 100), () async {
      await three3dRender.prepareContext();

      initScene();
    });
  }

  initSize(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Map'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          initSize(context);
          return MediaQuery.of(context).size.width > deskopModeWidth
              ? _buildDesktop(context)
              : _buildMobile(context);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigatorTimer?.cancel();
          resetCamera();
          resetLayout();
          resetBuilgingColor();
        },
        tooltip: 'reset location',
        child: Icon(Icons.home),
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
                        : Center(child: CircularProgressIndicator());
                  }));
            }),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          padding: EdgeInsets.all(16.0),
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
                                  BorderRadius.all(Radius.circular(16.0)),
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
            padding: EdgeInsets.all(16.0),
            child: _contentWidget())
      ],
    ));
  }

  Widget _contentWidget() {
    return Column(children: [
      InputDecorator(
        decoration: InputDecoration(
          labelText: 'Please select a location',
          prefixIcon: Icon(Icons.pin_drop),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
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
              return option.contains(textEditingValue.text.toLowerCase());
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
      Text('Selected Location Display Name: $_selectedLocationName'),
      Text('Selected Location Name: $_selectedLocation'),
      Text(
          'Description: ${_selectedLocation == '' ? "" : mapData[_selectedLocation]!['description']}'),
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
        print("render cost: ${t1 - t} ");
        print(renderer!.info.memory);
        print(renderer!.info.render);
      }
    }
    // 重要 更新纹理之前一定要调用 确保gl程序执行完毕
    gl.flush();
    // var pixels = _gl.readCurrentPixels(0, 0, 10, 10);
    // print(" --------------pixels............. ");
    // print(pixels);
    if (verbose) {
      if (kDebugMode) {
        print(" render: sourceTexture: $sourceTexture ");
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
      "width": width,
      "height": height,
      "gl": three3dRender.gl,
      "antialias": true,
      "canvas": three3dRender.element
    };
    renderer = three.WebGLRenderer(options);
    renderer!.setPixelRatio(dpr);
    renderer!.setSize(width, height, false);
    renderer!.shadowMap.enabled = false;
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
    controls.enableDamping =
        true; // an animation loop is required when either damping or auto-rotation are enabled
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

    // helper
    if (kDebugMode) {
      var grid = three.GridHelper(1000, 1000, 0xff0000, 0xffff);
      scene.add(grid);
      var cameraHelper = three.CameraHelper(camera);
      scene.add(cameraHelper);
      var axesHelper = three_dart.AxesHelper(3);
      scene.add(axesHelper);
    }

    // ground
    if (!kDebugMode) {
      // if (true) {
      var mesh = three.Mesh(
          three.PlaneGeometry(
              settingData['ground']['width'], settingData['ground']['length']),
          three.MeshPhongMaterial(
              {'color': settingData['ground']['color'], 'depthWrite': false}));
      mesh.rotation.x = -three.Math.pi / 2;
      mesh.receiveShadow = true;
      mesh.name = "ground";
      scene.add(mesh);
    }

    // buildings
    for (var i in mapData.keys) {
      // for import obj file
      if (mapData[i]!['render'] == false) {
        continue;
      }
      material = three.MeshPhongMaterial({
        'color': mapData[i]!["color"] ?? settingData['buildings']['color'],
        'flatShading': true,
      });
      var mesh = three.Mesh(geometry, material);
      mesh.position.x = mapData[i]!["x"];
      mesh.position.y = mapData[i]!["y"];
      mesh.position.z = mapData[i]!["z"];
      mesh.scale.x = mapData[i]!["length"];
      mesh.scale.y = mapData[i]!["height"];
      mesh.scale.z = mapData[i]!["width"];
      mesh.name = i;
      mesh.updateMatrix();
      mesh.matrixAutoUpdate = false;
      scene.add(mesh);
      if (kDebugMode) {
        print("mesh: $mesh");
      }
    }

    // lights
    // var light = three.DirectionalLight(0xffffff);
    // light.position.set(1, 1, 1);
    // scene.add(light);
    // var dirLight =
    //     three.DirectionalLight(settingData['lights']['directional']['color']);
    // dirLight.position.set(
    //     settingData['lights']['directional']['x'],
    //     settingData['lights']['directional']['y'],
    //     settingData['lights']['directional']['z']);
    // scene.add(dirLight);
    // var ambientLight =
    //     three.AmbientLight(settingData['lights']['ambient']['color']);
    // scene.add(ambientLight);

    for (var i in settingData['lights']) {
      if (i['type'] == 'ambient') {
        var ambientLight = three.AmbientLight(i['color']);
        ambientLight.intensity = i['intensity'];
        scene.add(ambientLight);
      } else if (i['type'] == 'point') {
        var pointLight = three.PointLight(i['color']);
        pointLight.position.set(i['x'], i['y'], i['z']);
        scene.add(pointLight);
      } else if (i['type'] == 'spot') {
        var spotLight = three.SpotLight(i['color']);
        spotLight.position.set(i['x'], i['y'], i['z']);
        scene.add(spotLight);
      } else if (i['type'] == 'hemisphere') {
        var hemisphereLight = three.HemisphereLight(
            i['skyColor'], i['groundColor'], i['intensity']);
        hemisphereLight.position.set(i['x'], i['y'], i['z']);
        scene.add(hemisphereLight);
      } else if (i['type'] == 'rectArea') {
        var rectAreaLight = three.RectAreaLight(
            i['color'], i['intensity'], i['width'], i['height']);
        rectAreaLight.position.set(i['x'], i['y'], i['z']);
        scene.add(rectAreaLight);
      } else if (i['type'] == 'directional') {
        var dirLight = three.DirectionalLight(i['color']);
        dirLight.position
            .set(i['position']['x'], i['position']['y'], i['position']['z']);
        dirLight.intensity = i['intensity'];
        dirLight.castShadow = i['shadow']['enabled'] ?? false;
        scene.add(dirLight);
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
    var x = mapData[buildingName]!["x"];
    var y = mapData[buildingName]!["y"];
    var z = mapData[buildingName]!["z"];
    var height = mapData[buildingName]!["height"];
    var length = mapData[buildingName]!["length"];
    var width = mapData[buildingName]!["width"];
    var object = scene.getObjectByName(buildingName);
    var tarCameraPosition = three.Vector3(
        x + length * 2, y + height * 2, z + width * 2); // TODO: Best position
    _navigatorTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!mounted || disposed) {
        timer.cancel();
        return;
      }
      var cameraPosition = camera.position;
      var distance = cameraPosition.distanceTo(tarCameraPosition);
      if (distance < 1) {
        timer.cancel();
        return;
      } else {
        // TODO: Best route
        cameraPosition.lerp(tarCameraPosition, 0.1);
      }
      controls.target.set(x, height / 2 + y, z);
    });
    for (var i in scene.children) {
      if (i is three.Mesh) {
        if (i.name == "ground") {
          continue;
        }
        if (i.name == buildingName) {
          i.material = three.MeshPhongMaterial({
            'color': settingData['buildings']['focusColor'],
            'flatShading': true,
            'opacity': 1,
            'transparent': false,
          });
        } else {
          i.material = three.MeshPhongMaterial({
            'color':
                mapData[i.name]!["color"] ?? settingData['buildings']['color'],
            'flatShading': true,
            'opacity': 0.5,
            'transparent': true,
          });
        }
      }
    }
  }

  resetCamera() {
    var x = settingData['camera']['focusX'];
    var y = settingData['camera']['focusY'];
    var z = settingData['camera']['focusZ'];
    var tarCameraPosition = three.Vector3(settingData['camera']['x'],
        settingData['camera']['y'], settingData['camera']['z']);
    _navigatorTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!mounted || disposed) {
        timer.cancel();
        return;
      }
      var cameraPosition = camera.position;
      var distance = cameraPosition.distanceTo(tarCameraPosition);
      if (distance < 1) {
        timer.cancel();
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
      if (i.name == "ground") {
        continue;
      }
      if (i is three.Mesh) {
        i.material = three.MeshPhongMaterial({
          'color':
              mapData[i.name]!["color"] ?? settingData['buildings']['color'],
          'flatShading': true,
          'opacity': 1,
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

    super.dispose();
  }
}
