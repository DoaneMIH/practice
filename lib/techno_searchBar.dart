import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(255, 226, 121, 1), Colors.white]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(207, 229, 251, 1.0)
                  ]),
            ),
            child: Column(
              children: [
                SizedBox(
                    height: 80,
                    child: Row(children: <Widget>[
                      SizedBox(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, icon: const Icon(Icons.arrow_back)),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: "Search Projects or Freelancing",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: const Icon((Icons.search))),
                        ),
                      )),
                    ])),
                const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Categories",
                        style: TextStyle(fontSize: 20, letterSpacing: 2))),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
        
              Container(
                width: 500,
                height: 130,
                color: Colors.white,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: Text("Accounting and Consulting", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),),
                    ),
        
                    const Spacer(flex: 20,),
        
                    InkWell(
                      onTap: (){},
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(padding:const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: Container(
                          height: 40,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromRGBO(255, 149, 0, 1),
                          ),
                          child: const Center(
                            child: Text(
                              "Browse",
                            style: TextStyle(fontSize: 15),
                            ),
                            ),
                                          ),
                        ),
                      ),
                    ),
                  
                  ],
                ),
              ),


              Container(
                width: 500,
                height: 130,
                color: Colors.white,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: Text("Admin Support", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),),
                    ),
        
                    const Spacer(flex: 20,),
        
                    InkWell(
                      onTap: (){},
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(padding:const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: Container(
                          height: 40,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromRGBO(255, 149, 0, 1),
                          ),
                          child: const Center(
                            child: Text(
                              "Browse",
                            style: TextStyle(fontSize: 15),
                            ),
                            ),
                                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 500,
                height: 130,
                color: Colors.white,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: Text("Customer Service", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),),
                    ),
        
                    const Spacer(flex: 20,),
        
                    InkWell(
                      onTap: (){},
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(padding:const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: Container(
                          height: 40,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromRGBO(255, 149, 0, 1),
                          ),
                          child: const Center(
                            child: Text(
                              "Browse",
                            style: TextStyle(fontSize: 15),
                            ),
                            ),
                                          ),
                        ),
                      ),
                    ),
                  
                  ],
                ),
              ),

              Container(
                width: 500,
                height: 130,
                color: Colors.white,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: Text("Data Science and Analysis", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),),
                    ),
        
                    const Spacer(flex: 20,),
        
                    InkWell(
                      onTap: (){},
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(padding:const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: Container(
                          height: 40,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromRGBO(255, 149, 0, 1),
                          ),
                          child: const Center(
                            child: Text(
                              "Browse",
                            style: TextStyle(fontSize: 15),
                            ),
                            ),
                                          ),
                        ),
                      ),
                    ),
                  
                  ],
                ),
              ),

              Container(
                width: 500,
                height: 130,
                color: Colors.white,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
                      child: Text("Design and Creative", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),),
                    ),
        
                    const Spacer(flex: 20,),
        
                    InkWell(
                      onTap: (){},
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(padding:const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: Container(
                          height: 40,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromRGBO(255, 149, 0, 1),
                          ),
                          child: const Center(
                            child: Text(
                              "Browse",
                            style: TextStyle(fontSize: 15),
                            ),
                            ),
                                          ),
                        ),
                      ),
                    ),
                  
                  ],
                ),
              )
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
