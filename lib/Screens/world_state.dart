import 'package:api_tutorial/Models/my_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import '../Services/states_services.dart';
import 'countries_list.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({Key? key}) : super(key: key);

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices=StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*.01,),

              FutureBuilder(
                future: statesServices.fetchWorldStatesRecords(),
                builder: (context,AsyncSnapshot<MyModel> snapshot){

                  if (!snapshot.hasData) {
                    return Expanded(
                      flex:1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,
                      ),
                      );
                  }
                  else{
                    return Column(
                      children: [
                        PieChart(
                dataMap:  {
                  'Total':double.parse(snapshot.data!.cases!.toString()),
                  'Discoverd':double.parse(snapshot.data!.recovered.toString()),
                  'Deaths':double.parse(snapshot.data!.deaths.toString()),
                },
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
                chartRadius: MediaQuery.of(context).size.width/3.2,
                legendOptions:const LegendOptions(
                  legendPosition: LegendPosition.left
                ),
                animationDuration: const Duration(milliseconds: 1500),
                chartType: ChartType.ring,
                colorList: colorList,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.06),
                  child: Card(
                    child: Column(
                      children: [
                        ReuseableRow(title: 'Total', value: snapshot.data!.cases.toString(),),
                        ReuseableRow(title: 'Active', value: snapshot.data!.active.toString(),),
                        ReuseableRow(title: 'Deaths', value: snapshot.data!.deaths.toString(),),
                        ReuseableRow(title: 'Recovered', value: snapshot.data!.recovered.toString(),),
                        ReuseableRow(title: 'Todat cases', value: snapshot.data!.todayCases.toString(),),
                        
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CountriesListScreen()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff1aa260),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:const Center(child: Text('Track Countries')),
                  ),
                ),

                      ],
                    );
                  }

                }
                ),

                

            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title,value;
   ReuseableRow({Key? key,required this.title,required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 5,left: 10,right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  Text(title),
                  Text(value),
            ],
          ),
          const SizedBox(height: 5,),
          const Divider(),
        ],
      ),
    );
    
  }
}
