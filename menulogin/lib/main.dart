import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

final ThemeData _themeData = new ThemeData(
  primaryColor: Colors.blueAccent,
);
var nama_user = "blank";

TextStyle mytext =  new TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w900,
      fontFamily: "Georgia",
    );

BoxDecoration bg = new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/bg.jpg"),fit: BoxFit.cover));
BoxDecoration bar = new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/bar.jpg"),fit: BoxFit.cover));

const jsoncodec = const JsonCodec();
var httpClient = createHttpClient();

final TextEditingController _username = new TextEditingController();
final TextEditingController _password = new TextEditingController();
final TextEditingController _konfirmasi = new TextEditingController();

final TextEditingController _username_daftar = new TextEditingController();
final TextEditingController _password_daftar = new TextEditingController();


MyDrawer drawerku = new MyDrawer();

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    var isi_menu_drawer = [];
    var isi_header_drawer = [];

    DrawerHeader header_drawer = new DrawerHeader(child: new ListView(children: isi_header_drawer,),decoration: bg,);
    Container header_contain =  new Container(child: header_drawer,width: 230.0,);
    Drawer menu_drawer = new Drawer(child: new ListView(children: isi_menu_drawer,));
    isi_header_drawer.add(new Text("\n\n\n\n" ));
    isi_header_drawer.add(new Text(nama_user,style:  new TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w900,
      fontFamily: "Georgia",
      color: Colors.white,
    ),));
    isi_menu_drawer.add(header_contain);
    isi_menu_drawer.add(new ListTile(title: new Text("menu Utama"),onTap: _drawertab_menu1,onLongPress: _drawertab_menu1));
    isi_menu_drawer.add(new ListTile(title: new Text("menu Kedua"),onTap: _drawertab_menu2,onLongPress: _drawertab_menu2));
    isi_menu_drawer.add(new ListTile(title: new Text("menu Ketiga"),onTap: _drawertab_menu3,onLongPress: _drawertab_menu3,));
    isi_menu_drawer.add(new ListTile(title: new Text("Logout"),onTap: _exit,));
    isi_header_drawer.add(new Text("\n\n\n\n" ));
    return menu_drawer;
  }


  _drawertab_menu1() {
    Navigator.of(context).pushNamed("/ke_menu_pertama");
  }
  _drawertab_menu2() {
    Navigator.of(context).pushNamed("/ke_menu_kedua");
  }
  _drawertab_menu3() {
    Navigator.of(context).pushNamed("/ke_menu_ketiga");
  }

  _exit(){
    Navigator.pop(context);

    Navigator.of(context).pushNamed("/kembali_ke_menu_login");
  }
}




class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _router = <String, WidgetBuilder> {
    "/menu_login" : (BuildContext context) => new MenuLogin(),
    "/menu_utama" : (BuildContext context) => new UtamaLandingPage(),
    "/menu_daftar" : (BuildContext context) => new MenuDaftar(),
  };


  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new MenuLogin(),
      routes: _router,
      theme: _themeData,
    );
  }


}


class UtamaLandingPage extends StatefulWidget {
  @override
  _UtamaLandingPageState createState() => new _UtamaLandingPageState();
}

class _UtamaLandingPageState extends State<UtamaLandingPage> {
  @override
  Widget build(BuildContext context) {
    var _utama_router = <String,WidgetBuilder> {
      "/kembali_ke_menu_login" : (BuildContext context) => new LandingPage(),
      "/ke_menu_pertama" : (BuildContext context) => new MenuUtama(),
      "/ke_menu_kedua" : (BuildContext context) => new MenuKedua(),
      "/ke_menu_ketiga" : (BuildContext context) => new MenuKetiga(),
    };


    return new MaterialApp(
      home: new MenuUtama(),
      routes: _utama_router,
        theme: _themeData
    );
  }
}




 



class MenuLogin extends StatefulWidget {
  @override
  _MenuLoginState createState() => new _MenuLoginState();
}

class _MenuLoginState extends State<MenuLogin> {
  @override
  Widget build(BuildContext context) {
    var isi_menu_login = [];
    isi_menu_login.add(new Text("\n\n\n\n\n\n\n\n"));
    isi_menu_login.add(new Center(child: new Text("Login",style: mytext)));

    isi_menu_login.add(new Text("\n"));
    isi_menu_login.add(new TextField(controller: _username,
      decoration: new InputDecoration(hintText: "Username"),));
    isi_menu_login.add(new  TextField(controller: _password,
      decoration: new InputDecoration(hintText: "Password"),));
    isi_menu_login.add(new Text("\n"));
    isi_menu_login.add(new RaisedButton(
      onPressed: _login, child: new Text("Login"),));
    isi_menu_login.add(new Text("\n"));
    isi_menu_login.add(new Center(child: new Container(child: new FlatButton(onPressed: _menu_daftar,child: new Text("Mendaftar"),),width: 150.0,)));
   isi_menu_login.add(new Text("\n\n\n\n" ));

    return new Scaffold(
      body: new Container(decoration: bg,child:new Center(child: new Container (
        child: new ListView(children: isi_menu_login,), width: 260.0,),),) ,);
  }

  _menu_daftar(){

    Navigator.of(context).pushNamed("/menu_daftar");
  }


  _login() async {

    if (_username.text.trim().toString().isEmpty){
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('perhatian'),content: new Text("username harap diisi"),
        ),
      );
      return;

    }

    if (_password.text.trim().toString().isEmpty){
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('perhatian'),content: new Text("password harap diisi"),
        ),
      );
      return;

    }

    String url = "http://192.168.23.1:9090/mau_login";
    var data = {"username": _username.text, "password": _password.text};
    var response = await httpClient.post(url, body: data);
    var hasil = jsoncodec.decode(response.body);

    bool ijin = hasil["Akses"];
    String username = hasil["Username"];

    _username.clear();
    _password.clear();

    if (ijin) {

      Navigator.of(context).pushNamed("/menu_utama");
      nama_user = "Nama : "+username +"\nUsername : "+ username;
    } else {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('Gagal login'),content: new Text("user dan password salah"),
        ),
      );

    }
  }


}

class MenuUtama extends StatefulWidget {
  @override
  _MenuUtamaState createState() => new _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama> {
  @override
  Widget build(BuildContext context) {
    var item_menu_utama =[];


    return new Scaffold(
      drawer:drawerku
      ,body:new Container(child: new ListView(children: item_menu_utama,),decoration: bg)
      ,appBar: new AppBar(title:new Text("Menu Utama"),flexibleSpace: new Container(decoration: bar,))
      );
  }
}


class MenuKedua extends StatefulWidget {
  @override
  _MenuKeduaState createState() => new _MenuKeduaState();
}

class _MenuKeduaState extends State<MenuKedua> {
  @override
  Widget build(BuildContext context) {

    var item_menu_kedua =[];

    return new Scaffold(backgroundColor: Colors.blue
        ,drawer:drawerku
        ,body:new Center(child: new Container(child: new ListView(children: item_menu_kedua,),),),
        appBar: new AppBar(title:new Text("Menu Kedua"),flexibleSpace: new Container(decoration: bar,))
    );
  }
}

class MenuKetiga extends StatefulWidget {
  @override
  _MenuKetigaState createState() => new _MenuKetigaState();
}

class _MenuKetigaState extends State<MenuKetiga> {
  @override
  Widget build(BuildContext context) {
    var item_menu_ketiga =[];

    return new Scaffold(backgroundColor: Colors.red
        ,drawer:drawerku
        ,body:new Center(child: new Container(child: new ListView(children: item_menu_ketiga,),),),
        appBar: new AppBar(title:new Text("Menu Ketiga"),flexibleSpace: new Container(decoration: bar,))
    );

  }
}



class MenuDaftar extends StatefulWidget {
  @override
  _MenuDaftarState createState() => new _MenuDaftarState();
}

class _MenuDaftarState extends State<MenuDaftar> {
  @override
  Widget build(BuildContext context) {
    var isi_menu_daftar = [];

    isi_menu_daftar.add(new Text("\n\n\n\n\n"));
    isi_menu_daftar.add(new Center(child: new Container(child: new Text("\n"),)));
    isi_menu_daftar.add(new Center(child: new Container(child: new Text("Mendaftar Baru",style: mytext,),)));
    isi_menu_daftar.add(new Center(child: new Container(child: new Text("\n"),)));
    isi_menu_daftar.add(new TextField(controller: _username_daftar, decoration: new InputDecoration(hintText: "masukkan username baru"),));
    isi_menu_daftar.add(new TextField(controller: _password_daftar, decoration: new InputDecoration(hintText: "masukkan password baru"),));
    isi_menu_daftar.add(new Text("\n"));
    isi_menu_daftar.add(new RaisedButton(onPressed: _daftar,child: new Text("Mendaftar"),));
    isi_menu_daftar.add(new Text("\n"));
    isi_menu_daftar.add(new FlatButton(onPressed: _batal,child: new Text("Batal"),));
    isi_menu_daftar.add(new Text("\n\n\n\n" ));


    return new Scaffold(appBar: new AppBar(title:new Text("Mendaftar Baru"),flexibleSpace: new Container(decoration: bar,)),body:new Container(decoration:bg,child: new Center(child: new Container(child: new ListView(children: isi_menu_daftar ,),width: 260.0,),),));
  }
  _daftar() async {
    String url = "http://192.168.23.1:9090/mau_mendaftar";
    var data = {"username":_username_daftar.text, "password": _password_daftar.text};
    var response = await httpClient.post(url, body: data);
    var hasil = jsoncodec.decode(response.body);

    bool ijin = hasil["Akses"];



    if (ijin) {
      _username_daftar.clear();
      _password_daftar.clear();
      Navigator.pop(context);
    } else {

    }
  }

  _batal(){
    Navigator.pop(context);
  }
}



void main() {
  runApp(new LandingPage());
}





