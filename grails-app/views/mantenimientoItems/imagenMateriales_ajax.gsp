<g:if test="${tipo == '2'}">
    <img src="${request.contextPath}/mantenimientoItems/getFotoRubro?id=${item?.id}" style="width: 100%; height: auto"/>
</g:if>
<g:else>
    <img src="${request.contextPath}/mantenimientoItems/getFoto?id=${item?.id}" style="width: 100%; height: auto"/>
</g:else>
