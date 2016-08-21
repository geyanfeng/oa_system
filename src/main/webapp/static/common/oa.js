//得到订单的帐期
function calcPoZq(po){
    var paymentDetails = JSON.parse(po.paymentDetail);
    var count = 0, sumTime = 0;
    $.each(paymentDetails, function(idx, paymentDetail){
        //帐期不等于0的,才参加计算
        if(paymentDetail.payment_installment_time != 0){
            count++;
            sumTime+= parseFloat(paymentDetail.payment_installment_time);
        }
    });
    if(sumTime!=0 || count!=0){
        po.zq = parseFloat(sumTime/count).toFixed(2);
        po.zqrll =(parseFloat(po.paymentPointnum) / (sumTime/count)).toFixed(4);
    } else{
        po.zq = 0;
        po.zqrll = 0;
    }
}