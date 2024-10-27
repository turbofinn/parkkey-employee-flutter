import 'package:flutter/material.dart';
class HistoryItem extends StatefulWidget {
  String name,vehicleNo,vehicleType;
  String? address,time,date,timer;
   HistoryItem(this.name,this.vehicleNo,this.vehicleType,this.address,this.time,this.date,this.timer,{super.key});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {

  @override
  Widget build(BuildContext context) {
    String assetImage = 'assets/images/';
    bool isVisibleFullCard = false;

    if(widget.address != null){
      isVisibleFullCard = true;
    }

    if(widget.vehicleType == 'Car'){
      assetImage += 'car.png';
    }
    else if(widget.vehicleType == 'Bike'){
      assetImage += 'bike.png';
    }
    else if(widget.vehicleType == 'Heavy Vehicle'){
      assetImage += 'truck.png';
    }
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 8,left: 12,right: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                // Adjust the shadow color and opacity
                blurRadius: 7, // Adjust the blur radius of the shadow
                //offset: Offset(2, 2,), // Offset of the shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    assetImage != "assets/images/" ? Container(
                      child: Image(
                        image: AssetImage(assetImage),
                      ),
                    ) : Container(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.name != "" ? Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        ) : Container(),
                        widget.vehicleNo != "" ?Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            widget.vehicleNo,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ) : Container(),
                        widget.vehicleType != "" ? Container(
                          margin: EdgeInsets.only(left: 50),
                          child: Text('Vehicle Type: ' + widget.vehicleType,style: TextStyle(fontSize: 12),),
                        ) : Container()
                      ],
                    )
                  ],
                ),
                isVisibleFullCard ? Visibility(
                  visible: isVisibleFullCard,
                  child: widget.address != "" ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text('Parked At: '+widget.address!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),),
                    ),
                  ) : Container(),
                ) : Container(),
                isVisibleFullCard ? Visibility(
                  visible: isVisibleFullCard,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.timer != "" ? Container(
                            child: Text(widget.timer!,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),),
                          ):Container(),
                          widget.date != "" ? Container(
                            child: Text(''+widget.date!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),),
                          ) : Container(),
                        ],
                      )
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      )
    );
  }
}
