<%-- 
    Document   : clientdashboard
    Created on : Dec 27, 2016, 11:35:43 PM
    Author     : Milan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
    </head>
    <body>
        <c:if test="${outcomeMessage!=null}">
            <p><c:out value="${outcomeMessage}" /></p>
        </c:if>

        <c:if test="${loggedAccount==null}">
            <%
                response.sendRedirect("http://localhost:8080/exchangomatic/clientlogin");
            %>
        </c:if>

        <a href="http://localhost:8080/exchangomatic/clientlogin">Log out</a>

        <h1>Client Dashboard</h1> 
        <input type="text" id="amount" placeholder="Enter amount here" /><br>
        <input type="text" id="rate" placeholder="Enter rate here" /><br>
        <button onclick="sendTransactionRequest()">Send Transaction Request</button><br>
        <h3>Transaction Offer ID's:</h3>
        <div id="offersDiv"></div>

        <h2>Accept Transaction Offer:</h2>
        <input type="text" id="offerId" placeholder="Enter Offer ID" /><br>

        <button onclick="saveCompletedTransaction()">Accept Offer</button>

        <script>
            function saveCompletedTransaction() {
                //fetching transaction offer first; may want to put into a separate function
                var xhr = new XMLHttpRequest();
                xhr.open("post", "http://localhost:8080/exchangomatic/fetchoffer/" + $("#offerId").val(), false);
                xhr.setRequestHeader("Content-Type", "application/json");
                var client = {};
                client.id = "${loggedAccount.id}";
                client.email = "${loggedAccount.email}";
                client.password = "${loggedAccount.password}";
                xhr.send(JSON.stringify(client));
                var offer = eval("(" + xhr.responseText + ")");
                
                var trans = {};
                trans.amount = offer.amount;
                trans.rate = offer.rate;
                trans.client = offer.client;
                trans.exchanger = offer.exchanger;
                trans.transactionOffer = offer;

                var xhr = new XMLHttpRequest();
                xhr.open("post", "http://localhost:8080/exchangomatic/savecompletedtransaction", false);
                xhr.setRequestHeader("Content-Type", "application/json");
                xhr.send(JSON.stringify(trans));
            }

            function fetchTransactionOffers() {
                document.getElementById("offersDiv").innerHTML = "";
                var client = {};
                client.id = "${loggedAccount.id}";
                client.email = "${loggedAccount.email}";
                client.password = "${loggedAccount.password}";
                var xhr = new XMLHttpRequest();
                xhr.open("post", "http://localhost:8080/exchangomatic/fetchoffers", false);
                xhr.setRequestHeader("Content-Type", "application/json");
                xhr.send(JSON.stringify(client));
                if(xhr.responseText === "[]"){ //prevents the function from trying to populate the div if the response is empty (i.e. there are no pending offers)
                    return;
                }

                var transactionOffers = eval("(" + xhr.responseText + ")");
                for (var i = 0; i < transactionOffers.length; i++) { //this loop is here only for the demo, get rid of it afterwards
                    //all transaction requests are available in this array - transactionRequests
                    //Front-enders will need to figure out a way to properly display the info (muhahahah, good luck!)
                    $("#offersDiv").append("offer id: " + transactionOffers[i].id);
                    $("#offersDiv").append(" - exchanger name " + transactionOffers[i].exchanger.name);
                    $("#offersDiv").append(" - amount: " + transactionOffers[i].amount);
                    $("#offersDiv").append(" - rate: " + transactionOffers[i].rate);
                    $("#offersDiv").append("<br>"); 
                }
                transactionOffers.length = 0;
            }

            function sendTransactionRequest() {
                var transactionRequest = {};
                transactionRequest.amount = parseFloat(document.getElementById("amount").value);
                transactionRequest.rate = parseFloat(document.getElementById("rate").value);
                var client = {};
                client.id = "${loggedAccount.id}";
                client.email = "${loggedAccount.email}";
                client.password = "${loggedAccount.password}";
                transactionRequest.client = client;
                var xhr = new XMLHttpRequest();
                xhr.open("post", "http://localhost:8080/exchangomatic/saverequest", false);
                xhr.setRequestHeader("Content-Type", "application/json");
                xhr.send(JSON.stringify(transactionRequest));
            }
            
            setInterval(fetchTransactionOffers, 5000);
        </script>
    </body>
</html>
