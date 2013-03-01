{{? "0" in sk}}
	{{= console.log(sk) }}
	<div>
		<img width="400" height="350" src='{{=Config.imageUrl("user_car",sk[0].id,sk[0].car_id) }}' />
	</div>
{{?}}