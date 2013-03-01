$(function() {
	$('#download_backup').click(function(){
	  window.open('http://localhost:3000/transactions.csv');
	  window.open('http://localhost:3000/transactions.xls');
	  window.open('http://localhost:3000/accounts.csv');
	  window.open('http://localhost:3000/accounts.xls');
	  window.open('http://localhost:3000/groups.csv');
	  window.open('http://localhost:3000/groups.xls');
	  window.open('http://localhost:3000/categories.csv');
	  window.open('http://localhost:3000/categories.xls');
	  return false;
	});
});	