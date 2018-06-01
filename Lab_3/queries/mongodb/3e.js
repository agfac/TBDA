db.facilities.find(
{
  $nor: [
  		{"MUNICIPALITIES.ACTIVITIES": {$size: 0}}
  		]},
  		{COD:1, DESIGNATION:1}
)