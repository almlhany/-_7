import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main()=> runApp(App());
class App extends StatelessWidget{
  @override Widget build(BuildContext c)=> MaterialApp(debugShowCheckedModeBanner:false, theme:ThemeData.dark(), home:Splash());
}

class LiveClock extends StatefulWidget{ const LiveClock({super.key}); @override State<LiveClock> createState()=>_C();}
class _C extends State<LiveClock>{
  late Timer t; DateTime n=DateTime.now();
  @override void initState(){super.initState(); t=Timer.periodic(Duration(seconds:1),(_)=>setState(()=>n=DateTime.now()));}
  @override void dispose(){t.cancel(); super.dispose();}
  @override Widget build(BuildContext c){ String p(int v)=>v.toString().padLeft(2,'0'); return Text("${p(n.hour)}:${p(n.minute)}:${p(n.second)}", style:TextStyle(fontSize:13, color:Colors.white));}
}

class MyUser{ String name,email,pass; Set<String> followed; List<String> inbox; MyUser(this.name,this.email,this.pass,{Set<String>? f, List<String>? ib}):followed=f??{}, inbox=ib??[];}
class Auth{
  static List<MyUser> users=[MyUser("goals_sa","g@g.com","123"), MyUser("sarah","s@s.com","123"), MyUser("انت","a@a.com","123")];
  static MyUser cur=MyUser("انت","a@a.com","123");
  static bool login(String e,String p){ for(var u in users){ if(u.email==e&&u.pass==p){cur=u; return true;}} return false;}
  static bool reg(String n,String e,String p){ if(users.any((u)=>u.email==e)) return false; var u=MyUser(n,e,p); users.add(u); cur=u; return true;}
}

class Comment{ String user,text; int likes; bool liked; Comment(this.user,this.text,{this.likes=0,this.liked=false});}
class Video{
  String id,user,desc,music; int likes,coms,shares,books; bool liked,booked; Color color; List<Comment> comments; String videoUrl;
  Video({required this.id,required this.user,required this.desc,required this.music,required this.color,required this.likes,required this.coms,required this.shares,required this.books,required this.videoUrl,this.liked=false,this.booked=false,List<Comment>? comments}):comments=comments??[];
}
class DB{
  static List<Video> vids=[
    // فيديوهات حقيقية من الانترنت - تجريبية
    Video(id:"1", user:"sarah", desc:"يومياتي كمصممة ✨ #fyp #تصميم", music:"الصوت الاصلي - sarah", color:Color(0xFF6C5CE7), likes:45200, coms:320, shares:1200, books:800, videoUrl:"https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4", comments:[Comment("ahmed","رهيب")]),
    Video(id:"2", user:"goals_sa", desc:"هدف اليوم خرافي ⚽️🔥 #كورة", music:"تعليق المباراة", color:Color(0xFF009688), likes:120000, coms:4500, shares:8000, books:2000, videoUrl:"https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4"),
    Video(id:"3", user:"tech.riyadh", desc:"كيف تسوي تطبيق في Klencod", music:"شرح تقني", color:Color(0xFFE17055), likes:89100, coms:900, shares:5000, books:3000, videoUrl:"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
  ];
  static void like(Video v){ v.liked=!v.liked; v.likes+= v.liked?1:-1; }
  static void book(Video v){ v.booked=!v.booked; v.books+= v.booked?1:-1; }
}

class Splash extends StatefulWidget{ @override State<Splash> createState()=>_S();}
class _S extends State<Splash>{
  @override void initState(){super.initState(); Future.delayed(Duration(seconds:1),(){ if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>Login()));});}
  @override Widget build(BuildContext c)=> Scaffold(backgroundColor:Colors.black, body:Center(child:Column(mainAxisSize:MainAxisSize.min, children:[Icon(Icons.music_note,size:70), SizedBox(height:10), Text("TikTok Clone", style:TextStyle(fontWeight:FontWeight.w900, fontSize:22)), SizedBox(height:20), CircularProgressIndicator(), SizedBox(height:10), LiveClock()])));
}

class Login extends StatefulWidget{ @override State<Login> createState()=>_L();}
class _L extends State<Login>{
  bool isLogin=true; final e=TextEditingController(text:"a@a.com"), p=TextEditingController(text:"123"), n=TextEditingController();
  void _do(){
    if(e.text.isEmpty||p.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("املأ البيانات"))); return;}
    bool ok=isLogin?Auth.login(e.text.trim(), p.text.trim()):Auth.reg(n.text.trim(), e.text.trim(), p.text.trim());
    if(ok) Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>TikHome()));
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(isLogin?"خطأ - استخدم a@a.com / 123":"الايميل موجود")));
  }
  @override Widget build(BuildContext c)=> Scaffold(backgroundColor:Color(0xFF0E0E0E), body:Padding(padding:EdgeInsets.all(20), child:Column(crossAxisAlignment:CrossAxisAlignment.stretch, children:[
    SizedBox(height:60), Text(isLogin?"تسجيل الدخول":"انشاء حساب", style:TextStyle(fontSize:28,fontWeight:FontWeight.w900)), SizedBox(height:6), Text("حساب جاهز: a@a.com / 123", style:TextStyle(color:Colors.white54, fontSize:12)), SizedBox(height:20),
    if(!isLogin) TextField(controller:n, decoration:InputDecoration(labelText:"الاسم", filled:true, fillColor:Colors.white10, border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none))), if(!isLogin) SizedBox(height:10),
    TextField(controller:e, decoration:InputDecoration(labelText:"الايميل", filled:true, fillColor:Colors.white10, border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none))), SizedBox(height:10),
    TextField(controller:p, obscureText:true, decoration:InputDecoration(labelText:"كلمة المرور", filled:true, fillColor:Colors.white10, border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none))), SizedBox(height:20),
    FilledButton(onPressed:_do, style:FilledButton.styleFrom(padding:EdgeInsets.all(16)), child:Text(isLogin?"دخول":"انشاء", style:TextStyle(fontWeight:FontWeight.bold))), SizedBox(height:10),
    TextButton(onPressed:()=>setState(()=>isLogin=!isLogin), child:Text(isLogin?"ما عندك حساب؟ انشئ حساب":"عندك حساب؟ سجل دخول")),
    Spacer(), Row(mainAxisAlignment:MainAxisAlignment.center, children:[LiveClock(), SizedBox(width:8), Text("يعمل مع انترنت ✓", style:TextStyle(color:Colors.white54, fontSize:11))]),
  ]))));
}

class TikHome extends StatefulWidget{ @override State<TikHome> createState()=>_H();}
class _H extends State<TikHome>{
  int topTab=1; int bottomTab=0;
  String searchQuery="";
  List<Video> get filtered{
    List<Video> base = topTab==0? (DB.vids.where((v)=> Auth.cur.followed.contains(v.user)).toList().isEmpty? DB.vids : DB.vids.where((v)=> Auth.cur.followed.contains(v.user)).toList()) : DB.vids;
    if(searchQuery.isEmpty) return base;
    return base.where((v)=> v.user.toLowerCase().contains(searchQuery.toLowerCase()) || v.desc.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  void _showSearch(){
    showModalBottomSheet(context:context, isScrollControlled:true, backgroundColor:Color(0xFF121212), builder:(_)=> StatefulBuilder(builder:(ctx,set){
      return Padding(padding:EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom, left:16,right:16,top:16), child:Column(mainAxisSize:MainAxisSize.min, children:[
        TextField(autofocus:true, onChanged:(q){ setState(()=> searchQuery=q); set((){});}, decoration:InputDecoration(hintText:"بحث عن @sarah او #كورة...", prefixIcon:Icon(Icons.search), filled:true, fillColor:Colors.white10, border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
        SizedBox(height:12),
        if(searchQuery.isNotEmpty) Text("نتائج البحث: ${filtered.length} فيديو"),
        SizedBox(height:12),
        SizedBox(height:300, child:ListView.builder(itemCount:filtered.length, itemBuilder:(_,i)=> ListTile(leading:CircleAvatar(child:Text(filtered[i].user[0])), title:Text(filtered[i].user), subtitle:Text(filtered[i].desc, maxLines:1), onTap:(){ Navigator.pop(context); setState(()=> topTab=1);}))),
        SizedBox(height:20),
      ]));
    }));
  }

  void _addVideo(){
    String d=""; String url=""; var col=Colors.primaries[DateTime.now().second%Colors.primaries.length];
    showModalBottomSheet(context:context, isScrollControlled:true, backgroundColor:Color(0xFF1E1E1E), builder:(_)=> Padding(padding:EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom, left:16,right:16,top:16), child:Column(mainAxisSize:MainAxisSize.min, children:[
      Text("اضافة فيديو جديد من الانترنت", style:TextStyle(fontWeight:FontWeight.bold, fontSize:16)), SizedBox(height:10),
      TextField(maxLines:2, onChanged:(v)=>d=v, decoration:InputDecoration(hintText:"الوصف... #fyp", filled:true, fillColor:Colors.white10, border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none))),
      SizedBox(height:10),
      TextField(onChanged:(v)=>url=v, decoration:InputDecoration(hintText:"رابط الفيديو mp4 (اختياري - اذا فاضي بيحط لون)", filled:true, fillColor:Colors.white10, border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none))),
      SizedBox(height:6),
      Text("جرب هذا الرابط: https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4", style:TextStyle(fontSize:9, color:Colors.white54)),
      SizedBox(height:10),
      SizedBox(width:double.infinity, child:FilmedButton(onPressed:(){
        if(d.isNotEmpty){
          setState(()=> DB.vids.insert(0,Video(id:DateTime.now().millisecondsSinceEpoch.toString(), user:Auth.cur.name, desc:d, music:"الصوت الاصلي - ${Auth.cur.name}", color:col, likes:0, coms:0, shares:0, books:0, videoUrl: url.isEmpty? "" : url)));
          Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("تم نشر الفيديو ✅")));
        }
      }, label:"نشر الفيديو")), SizedBox(height:20)
    ])));
  }

  @override Widget build(BuildContext context)=> Scaffold(
    body: bottomTab==0? Stack(children:[
      PageView.builder(scrollDirection:Axis.vertical, itemCount:filtered.length, itemBuilder:(_,i)=> VideoItem(video:filtered[i], refresh:()=>setState((){}))),
      SafeArea(child: Padding(padding:EdgeInsets.symmetric(horizontal:16, vertical:8), child: Row(children:[
        LiveClock(),
        Spacer(),
        GestureDetector(onTap:()=>setState(()=>topTab=0), child:Text("متابعون", style:TextStyle(fontWeight:topTab==0?FontWeight.w900:FontWeight.w400, fontSize:16, color:topTab==0?Colors.white:Colors.white60))),
        SizedBox(width:16),
        GestureDetector(onTap:()=>setState(()=>topTab=1), child:Text("For You لك", style:TextStyle(fontWeight:topTab==1?FontWeight.w900:FontWeight.w400, fontSize:16, color:topTab==1?Colors.white:Colors.white60))),
        Spacer(),
        GestureDetector(onTap:_showSearch, child:Icon(Icons.search, size:28)),
      ]))),
    ]) : bottomTab==1? Center(child:Text("اصدقاء\n${Auth.cur.followed.join('\n')}", textAlign:TextAlign.center)) : bottomTab==3? InboxPage() : ProfilePage(),
    bottomNavigationBar: BottomNavigationBar(backgroundColor:Colors.black, selectedItemColor:Colors.white, unselectedItemColor:Colors.white54, type:BottomNavigationBarType.fixed, currentIndex:bottomTab, onTap:(i){ if(i==2){ _addVideo(); } else { setState(()=>bottomTab=i); } }, items:[
      BottomNavigationBarItem(icon:Icon(Icons.home_filled), label:"الرئيسية"),
      BottomNavigationBarItem(icon:Icon(Icons.people), label:"اصدقاء"),
      BottomNavigationBarItem(icon:Container(padding:EdgeInsets.symmetric(horizontal:18, vertical:4), decoration:BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(8), border:Border.all(color:Color(0xFFFE2C55), width:2.5)), child:Icon(Icons.add, color:Colors.black, size:24)), label:""),
      BottomNavigationBarItem(icon:Icon(Icons.inbox), label:"صندوق"),
      BottomNavigationBarItem(icon:Icon(Icons.person), label:"حسابي"),
    ]),
  );
}

class FilmedButton extends StatelessWidget{ final VoidCallback onPressed; final String label; const FilmedButton({required this.onPressed, required this.label}); @override Widget build(BuildContext c)=> FilledButton(onPressed:onPressed, style: FilledButton.styleFrom(backgroundColor:Color(0xFFFE2C55)), child:Text(label, style:TextStyle(fontWeight:FontWeight.bold)));}

// ===== عنصر الفيديو - يشغل فيديو انترنت =====
class VideoItem extends StatefulWidget{
  final Video video; final VoidCallback refresh; const VideoItem({required this.video, required this.refresh});
  @override State<VideoItem> createState()=>_VI();
}
class _VI extends State<VideoItem>{
  VideoPlayerController? _ctrl;
  bool _hasVideo=false;

  @override void initState(){
    super.initState();
    if(widget.video.videoUrl.isNotEmpty && widget.video.videoUrl.startsWith("http")){
      _hasVideo=true;
      _ctrl=VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))..initialize().then((_) { setState((){}); _ctrl!.setLooping(true); _ctrl!.play(); });
    }
  }
  @override void dispose(){ _ctrl?.dispose(); super.dispose();}

  @override Widget build(BuildContext context){
    bool isFollowed=Auth.cur.followed.contains(widget.video.user);
    return Stack(children:[
      // الفيديو او اللون
      Positioned.fill(child: _hasVideo && _ctrl!=null && _ctrl!.value.isInitialized
       ? GestureDetector(onTap:(){ setState(()=> _ctrl!.value.isPlaying? _ctrl!.pause() : _ctrl!.play());}, child:VideoPlayer(_ctrl!))
        : Container(color:widget.video.color, child:Center(child:Icon(Icons.play_arrow,size:80,color:Colors.black26)))
      ),
      if(_hasVideo && _ctrl!=null &&!_ctrl!.value.isPlaying) Center(child:Icon(Icons.play_arrow, size:80, color:Colors.white60)),
      // الاسم والوصف
      Positioned(left:12,right:80,bottom:18, child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Text("@${widget.video.user}", style:TextStyle(fontWeight:FontWeight.w900, fontSize:16)),
        SizedBox(height:4), Text(widget.video.desc, style:TextStyle(fontSize:13)),
        SizedBox(height:6), Row(children:[Icon(Icons.music_note,size:13), SizedBox(width:4), Expanded(child:Text(widget.video.music, overflow:TextOverflow.ellipsis, style:TextStyle(fontSize:11, color:Colors.white70)))])
      ])),
      // الازرار
      Positioned(right:8,bottom:90, child:Column(children:[
        GestureDetector(onTap:(){ if(isFollowed){ Auth.cur.followed.remove(widget.video.user); } else { Auth.cur.followed.add(widget.video.user); Auth.cur.inbox.add("تابعت @${widget.video.user}"); } widget.refresh(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(isFollowed?"الغيت متابعة @${widget.video.user}":"تابعت @${widget.video.user} ✅")));}, child:Stack(children:[CircleAvatar(radius:28, backgroundColor:Colors.white, child:Text(widget.video.user[0].toUpperCase(), style:TextStyle(color:Colors.black, fontWeight:FontWeight.bold, fontSize:22))), Positioned(bottom:0, left:0, right:0, child:Container(decoration:BoxDecoration(color:isFollowed?Colors.white:Color(0xFFFE2C55), shape:BoxShape.circle, border:Border.all(color:Color(0xFF009688), width:2)), child:Icon(isFollowed?Icons.check:Icons.add, size:16, color:isFollowed?Colors.black:Colors.white)))])),
        SizedBox(height:18),
        GestureDetector(onTap:(){ DB.like(widget.video); if(widget.video.liked) Auth.cur.inbox.add("اعجبت بفيديو @${widget.video.user}"); widget.refresh();}, child:Column(children:[Icon(widget.video.liked?Icons.favorite:Icons.favorite_border, color:widget.video.liked?Colors.red:Colors.white, size:34), Text(widget.video.likes>=1000?"${(widget.video.likes/1000).toStringAsFixed(1)}K":"${widget.video.likes}", style:TextStyle(fontSize:11, fontWeight:FontWeight.bold))])),
        SizedBox(height:14),
        GestureDetector(onTap:(){
          String inp=""; showModalBottomSheet(context:context, isScrollControlled:true, backgroundColor:Color(0xFF121212), builder:(_)=> DraggableScrollableSheet(initialChildSize:0.75, maxChildSize:0.92, expand:false, builder:(_,sc)=> Column(children:[Padding(padding:EdgeInsets.all(12), child:Text("${widget.video.coms} تعليق", style:TextStyle(fontWeight:FontWeight.bold))), Divider(height:1), Expanded(child:ListView.builder(controller:sc, itemCount:widget.video.comments.length, itemBuilder:(_,i)=> ListTile(leading:CircleAvatar(radius:16, child:Text(widget.video.comments[i].user[0])), title:Text(widget.video.comments[i].user, style:TextStyle(fontSize:12, fontWeight:FontWeight.bold)), subtitle:Text(widget.video.comments[i].text)))), Padding(padding:EdgeInsets.all(8), child:Row(children:[Expanded(child:TextField(onChanged:(v)=>inp=v, decoration:InputDecoration(hintText:"اضف تعليق...", filled:true, fillColor:Colors.white10, border:OutlineInputBorder(borderRadius:BorderRadius.circular(20),borderSide:BorderSide.none)))), IconButton(onPressed:(){ if(inp.isNotEmpty){ setState(()=> widget.video.comments.insert(0,Comment(Auth.cur.name,inp))); setState(()=> widget.video.coms++); Navigator.pop(context);} }, icon:Icon(Icons.send, color:Color(0xFFFE2C55)))]))])));}, child:Column(children:[Icon(Icons.chat_bubble, size:30), Text("${widget.video.coms}", style:TextStyle(fontSize:11, fontWeight:FontWeight.bold))])),
        SizedBox(height:14),
        GestureDetector(onTap:(){ DB.book(widget.video); widget.refresh(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(widget.video.booked?"تم الحفظ 🔖":"تم الازالة")));}, child:Column(children:[Icon(widget.video.booked?Icons.bookmark:Icons.bookmark_border, color:widget.video.booked?Colors.yellow:Colors.white, size:30), Text("${widget.video.books}", style:TextStyle(fontSize:11, fontWeight:FontWeight.bold))])),
        SizedBox(height:14),
        GestureDetector(onTap:(){ widget.video.shares++; widget.refresh();}, child:Column(children:[Icon(Icons.share, size:30), Text("${widget.video.shares}", style:TextStyle(fontSize:11, fontWeight:FontWeight.bold))])),
        SizedBox(height:14),
        GestureDetector(onTap:(){ showModalBottomSheet(context:context, builder:(_)=> Column(mainAxisSize:MainAxisSize.min, children:[ListTile(leading:Icon(Icons.report), title:Text("ابلاغ")), ListTile(leading:Icon(Icons.not_interested), title:Text("غير مهتم"))]));}, child:Icon(Icons.more_horiz, size:26)),
      ])),
    ]);
  }
}

class InboxPage extends StatelessWidget{ @override Widget build(BuildContext c)=> Scaffold(appBar:AppBar(title:Text("صندوق الوارد")), body:ListView(children: Auth.cur.inbox.isEmpty? [Padding(padding:EdgeInsets.all(20), child:Text("لا يوجد اشعارات"))] : Auth.cur.inbox.reversed.map((m)=> ListTile(leading:Icon(Icons.favorite, color:Colors.red), title:Text(m))).toList()));}
class ProfilePage extends StatelessWidget{
  @override Widget build(BuildContext c){
    var mine=DB.vids.where((v)=>v.user==Auth.cur.name).toList();
    var saved=DB.vids.where((v)=>v.booked).toList();
    return DefaultTabController(length:2, child:Scaffold(appBar:AppBar(title:Text("@${Auth.cur.name}"), actions:[LiveClock(), SizedBox(width:10)], bottom:TabBar(tabs:[Tab(text:"فيديوهاتي"), Tab(text:"المحفوظات")])), body:Column(children:[
      SizedBox(height:12), CircleAvatar(radius:40, child:Text(Auth.cur.name[0], style:TextStyle(fontSize:28))), SizedBox(height:6), Text("@${Auth.cur.name}", style:TextStyle(fontWeight:FontWeight.bold)), SizedBox(height:10),
      Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly, children:[_st("${Auth.cur.followed.length}","متابعين"), _st("${DB.vids.length}","متابَع"), _st("${DB.vids.fold(0,(a,b)=>a+b.likes)}","اعجابات")]),
      SizedBox(height:10), Divider(height:1),
      Expanded(child:TabBarView(children:[
        GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3, crossAxisSpacing:2, mainAxisSpacing:2), itemCount:mine.length, itemBuilder:(_,i)=> Container(color:mine[i].color, child:Center(child:Text("${mine[i].likes}")))),
        GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3, crossAxisSpacing:2, mainAxisSpacing:2), itemCount:saved.length, itemBuilder:(_,i)=> Container(color:saved[i].color, child:Icon(Icons.bookmark))),
      ]))
    ])));
 