
<%@ page contentType="text/html; charset=UTF-8" language="java" isELIgnored="false" %>
<script>
    $(function(){
        var deleteOrder=true;
        var deleteOrderid=0;

        $("a[orderStatus]").click(function(){
            var orderStatus = $(this).attr("orderStatus");
            if('all'==orderStatus){
                $("table[orderStatus]").show();
            }
            else{
                $("table[orderStatus]").hide();
                $("table[orderStatus="+orderStatus+"]").show();
            }

            $("div.orderType div").removeClass("selectedOrderType");
            $(this).parent("div").addClass("selectedOrderType");
        });



        $("a.deleteOrderLink").click(function () {
             deleteOrderid = $(this).attr("oid");
            deleteOrder=false;
            $("#deleteConfirmModal").modal("show");
        });
        $("button.deleteConfirmButton").click(function () {
            deleteOrder=true;
            $("#deleteConfirmModal").modal('hide');
        });
        $('#deleteConfirmModal').on('hidden.bs.modal', function (e) {
            if(deleteOrder){
                var page="foreDeleteOrder";
                $.post(
                    page,
                    {"oid":deleteOrderid},
                    function(result){
                        if("success"==result){
                            $("table.orderListItemTable[oid="+deleteOrderid+"]").hide();
                        }
                        else{
                            location.href="login.jsp";
                        }
                    }
                );

            }
        });

        $(".ask2delivery").click(function(){
            var link = $(this).attr("link");
            $(this).hide();
            page = link;
            $.ajax({
                url: page,
                success: function(result){
                    alert("卖家发货啦，刷新当前页面,可进行确认收货")
                }
            });
        });
    })

</script>
<div class="boughtDiv">
    <div class="orderType">
        <div class="selectedOrderType"><a orderStatus="all" href="#nowhere">所有订单</a></div>
        <div ><a orderStatus="waitPay" href="#nowhere">待付款</a></div>
        <div ><a orderStatus="waitDelivery" href="#nowhere">代发货</a></div>
        <div ><a orderStatus="waitConfirm" href="#nowhere">待收货</a></div>
        <div ><a orderStatus="waitConfirm" href="#nowhere" class="noRightborder">待评价</a></div>
        <div class="orderTypeLastOne"><a class="noRightborder">&nbsp;</a></div>
    </div>
    <div style="clear:both"></div>


    <div class="orderListTitle">
        <table class="orderListItemTable">
            <tr style=" background-color: #F1F1F1">
                <td align="center">宝贝</td>
                <td  width="100px">单价</td>
                <td  width="100px">数量</td>
                <td  width="120px">实付款</td>
                <td  width="100px">交易操作</td>
            </tr>
        </table>
    </div>

    <div class="orderListItem">
        <c:forEach items="${os}" var="o">
            <table class="orderListItemTable" orderStatus="${o.status}" oid="${o.id}">
                <tr class="orderListItemFirstTR">
                    <td colspan="2">
                        <b><fmt:formatDate value="${o.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></b>
                        <span>订单号: ${o.orderCode}
                    </span>
                    </td>

                    <td  colspan="2"><img width="13px" src="img/site/orderItemTmall.png">天猫商场</td>


                    <td colspan="1">
                        <a class="wangwanglink" href="#nowhere">
                            <div class="orderItemWangWangGif"></div>
                        </a>
                    </td>

                    <td style="text-align: right">
                        <a class="deleteOrderLink" oid="${o.id}" href="#nowhere">
                            <span class="glyphicon glyphicon-trash"></span>
                        </a>
                    </td>
                </tr>
                <c:forEach items="${o.orderItems}" var="oi" varStatus="st">
                    <tr class="orderItemProductInfoPartTR">
                        <td class="orderItemProductInfoPartTD">
                            <img width="80" height="80" src="img/productSingleMiddle/${oi.product.firstProductImage.id}.jpg">
                        </td>

                        <td class="orderItemProductInfoPartTD">
                            <div class="orderListItemProductLinkOutDiv">
                                <a href="foreproduct?pid=${oi.product.id}">${oi.product.name}</a>
                                <div class="orderListItemProductLinkInnerDiv">
                                    <img src="img/site/creditcard.png" title="支持信用卡支付">
                                    <img src="img/site/7day.png" title="消费者保障服务,承诺7天退货">
                                    <img src="img/site/promise.png" title="消费者保障服务,承诺如实描述">
                                </div>
                            </div>
                        </td>

                        <td class="orderItemProductInfoPartTD" style="border:solid 1px #ECECEC;" width="100px">
                            <div class="orderListItemProductOriginalPrice">
                                ￥<fmt:formatNumber type="number" value="${oi.product.originalPrice}" minIntegerDigits="2"></fmt:formatNumber>
                            </div>
                            <div style="color: black;font-size: 14px" >
                                ￥<fmt:formatNumber type="number" value="${oi.product.promotePrice}" minIntegerDigits="2"></fmt:formatNumber>
                            </div>
                        </td>
                            <%--row横跨表格--%>
                      <c:if test="${st.count==1}">
                        <td class="orderItemProductInfoPartTD"style="border:solid 1px #ECECEC;" valign="top" align="center" rowspan="${fn:length(o.orderItems)}" width="100px">
                            <span style="color: black">${o.orderNumber}</span>
                        </td>

                        <td class="orderItemProductInfoPartTD orderListItemProductRealPriceTD" rowspan="${fn:length(o.orderItems)}" width="120px" c>
                            <div class="orderListItemProductRealPrice">
                                ￥<fmt:formatNumber  minFractionDigits="2"  maxFractionDigits="2" type="number" value="${o.orderMoney}"/>
                            </div>
                            <div class="orderListItemPriceWithTransport">(含运费：￥0.00)</div>
                        </td>

                        <td valign="top" rowspan="${fn:length(o.orderItems)}" class="orderListItemButtonTD orderItemOrderInfoPartTD" width="100px">
                            <c:if test="${o.status=='waitConfirm'}">
                                <a href="foreConfirmPay?oid=${o.id}">
                                    <button class="orderListItemConfirm">确认收货</button>
                                </a>
                            </c:if>
                            <c:if test="${o.status=='waitPay'}">
                                <a href="foreAlipay?oid=${o.id}&total=${o.orderMoney}">
                                    <button class="orderListItemConfirm">付款</button>
                                </a>
                            </c:if>
                            <c:if test="${o.status=='waitDelivery' }">
                                <span>待发货</span>
                                <button class="btn btn-info btn-sm ask2delivery" link="adminOderDeliver?id=${o.id}">催卖家发货</button>
                            </c:if>
                            <c:if test="${o.status=='waitReview' }">
                                <a href="foreReview?oid=${o.id}">
                                    <button  class="orderListItemReview">评价</button>
                                </a>
                            </c:if>
                        </td>
                      </c:if>
                    </tr>
                </c:forEach>
            </table>
        </c:forEach>
    </div>
</div>