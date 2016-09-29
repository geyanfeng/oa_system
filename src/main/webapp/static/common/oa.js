//得到订单的帐期
function calcPoZq(po){
    var paymentDetails = po.purchaseOrderFinanceList;
    var count = 0, sumTime = 0;
    $.each(paymentDetails, function(idx, paymentDetail){
        //帐期不等于0的,才参加计算
        if(paymentDetail.zq != 0){
            count++;
            sumTime+= parseFloat(paymentDetail.zq);
        }
    });
    if(sumTime!=0 || count!=0){
        po.zq = parseFloat(sumTime/count).toFixed(2);
        po.zqrll =(parseFloat(po.paymentPointnum) / (sumTime/count)).toFixed(4) * 100;
    } else{
        po.zq = 0;
        po.zqrll = 0;
    }
}