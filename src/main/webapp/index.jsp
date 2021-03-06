<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCUMENT html>
<html>
<head>
    <title>Tic Tac Toe</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
<style type="text/css" media="screen">
  img{
    margin:0;
    padding:0;
  }

  td {
    border: 0px solid transparent;
    height: 100px;
    width: 100px;
    border-style: solid;
    border-width: 15px;
    background-color: black;
    padding:0px;
  }

  #minimax{
    font-size: 7em;
    color: white;
  }

  html{
    width:100%;
    height:100%;
    text-shadow: 1px 1px 2px grey;
    background-image: url('circle.gif');
    background-position: bottom left;
    background-repeat: no-repeat;
    background-color: black;
  }

  body{
    background-image: url('spinner.gif');
    background-size: 20% 200%;
    background-repeat: no-repeat;
    background-position: bottom right;
    background-color: transparent;
  }

  body, .container-fluid{
    background-color: transparent;
  }

  #board{
    background-image: url('bg.jpg');
    background-size: 100% 100%;
  }

  #board td{
    background-color: transparent;
  }
  </style>
</head>
<body>
<div class= "container-fluid text-center">
  <div class="ccontainer">  
    <div class="jumbotron" style="background-color: transparent; padding-bottom: 0px">
      <h1><b id="choose_prompt" style="color: #FFF">AI Simulation using Minimax Algorithm</b></h1>
      <h1><b id="selected" style="text-shadow: none"></b></h1>
    </div>
    <div class="col-md-12 text-center" style="padding-bottom: 100px">
      <div style="display:inline-block" id="board">
        <table>
          <tr>
              <td class = "cell" id = "0"><img src="black.jpg" width=0 height=0></td>
              <td class = "cell" id = "1"><img src="black.jpg" width=0 height=0></td>
              <td class = "cell" id = "2"><img src="black.jpg" width=0 height=0></td>
          </tr>
          <tr>
              <td class = "cell" id = "3"><img src="black.jpg" width=0 height=0></td>
              <td class = "cell" id = "4"><img src="black.jpg" width=0 height=0></td>
              <td class = "cell" id = "5"><img src="black.jpg" width=0 height=0></td>
          </tr>
          <tr>
              <td class = "cell" id = "6"><img src="black.jpg" width=0 height=0></td>
              <td class = "cell" id = "7"><img src="black.jpg" width=0 height=0></td>
              <td class = "cell" id = "8"><img src="black.jpg" width=0 height=0></td>
          </tr>
      </table>
      </div>
    </div>

    <div class="jumbotron" style="background-color: transparent; padding-bottom: 0px;">
      <b><span id="minimax" style="text-shadow: none">0</span></b>
    </div>
    <h3 class="" style="color: white">Latest Minimax Rating</h3>
  </div>
</div>

<script>
$(document).ready(function() {
  $("td").click(function() {
    move(this, huPlayer, symbolPl);
  });
});
var board = [0, 1, 2, 3, 4, 5, 6, 7, 8];
var huPlayer = "P";
var aiPlayer = "C";
var iter = 0;
var round = 0;
var huCo = "#edd299";
var aiCo = "green";
var rating= 0;
var symbolPl= 'y.jpg';
var symbolAi= 'x.jpg';

function move(element, player, symbol) {
  if (board[element.id] != "P" && board[element.id] != "C") {
    round++;
    $(element).find('img').attr('src', symbol);
    $(element).find('img').animate({'width':'80', 'height':'80'}, 300);
    setTimeout(function(){
      board[element.id] = player;

    if (winning(board, player)) {
      setTimeout(function() {
        alert("YOU WIN");
        reset();
      }, 500);
      return;
    } else if (round > 8) {
      setTimeout(function() {
        alert("TIE");
        reset();
      }, 500);
      return;
    } else {
      round++;
      var index = minimax(board, aiPlayer).index;
    $('#minimax').text(minimax(board, aiPlayer).score);
    var selector = "#" + index;
    $('#minimax').text(minimax(board, aiPlayer).score);
    $(selector).find('img').attr('src', symbolAi);
    $(selector).find('img').animate({'width':'80', 'height':'80'}, 300);
      board[index] = aiPlayer;
      if (winning(board, aiPlayer)) {
        setTimeout(function() {
          alert("YOU LOSE");
          reset();
        }, 500);
        return;
      } else if (round === 0) {
        setTimeout(function() {
          alert("tie");
          reset();
        }, 500);
        return;
      }
    }
    }, 300);    
  }
}

function reset() {
  round = 0;
  board = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  $("td img").animate({'width':'0', 'height':'0'}, 1000, function(){
    $("td img").attr('src', 'black.jpg');
  });
}

function minimax(reboard, player) {
  iter++;
  let array = avail(reboard);
  if (winning(reboard, huPlayer)) {
    return {
      score: -10
    };
  } else if (winning(reboard, aiPlayer)) {
    return {
      score: 10
    };
  } else if (array.length === 0) {
    return {
      score: 0
    };
  }

  var moves = [];
  for (var i = 0; i < array.length; i++) {
    var move = {};
    move.index = reboard[array[i]];
    reboard[array[i]] = player;

    if (player == aiPlayer) {
      var g = minimax(reboard, huPlayer);
      move.score = g.score;
    } else {
      var g = minimax(reboard, aiPlayer);
      move.score = g.score;
    }
    reboard[array[i]] = move.index;
    moves.push(move);
  }

  var bestMove;
  if (player === aiPlayer) {
    var bestScore = -10000;
    for (var i = 0; i < moves.length; i++) {
      if (moves[i].score > bestScore) {
        bestScore = moves[i].score;
        bestMove = i;
      }
    }
  } else {
    var bestScore = 10000;
    for (var i = 0; i < moves.length; i++) {
      if (moves[i].score < bestScore) {
        bestScore = moves[i].score;
        bestMove = i;
      }
    }
  }
  return moves[bestMove];
}

function avail(reboard) {
  return reboard.filter(s => s != "P" && s != "C");
}

function winning(board, player) {
  if (
    (board[0] == player && board[1] == player && board[2] == player) ||
    (board[3] == player && board[4] == player && board[5] == player) ||
    (board[6] == player && board[7] == player && board[8] == player) ||
    (board[0] == player && board[3] == player && board[6] == player) ||
    (board[1] == player && board[4] == player && board[7] == player) ||
    (board[2] == player && board[5] == player && board[8] == player) ||
    (board[0] == player && board[4] == player && board[8] == player) ||
    (board[2] == player && board[4] == player && board[6] == player)
  ) {
    return true;
  } else {
    return false;
  }
}
</script>
</body>
</html>
	
	
	
	
<script type="javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"> </script>
</body>
</html>