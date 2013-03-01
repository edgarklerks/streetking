{{ for (var tab = 0; tab < sk.nodes.length; tab++) { }}
    <a href="#{{=sk.requestParams.action}}/?part_type={{= sk.nodes[tab].content.Tab[0]}}&car_id={{= sk.requestParams.car_id || ''}}" class="tab-item-box" module="{{=sk.requestParams.module}}">
        <div class="tab-item-content icon-{{= sk.nodes[tab].content.Tab[0].toLowerCase()}}">&nbsp;</div>
    </a>
{{ } }}
