
<%@ page import="poa.Presupuesto" %>

<g:if test="${!presupuestoInstance}">
    <elm:notFound elem="Presupuesto" genero="o" />
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${presupuestoInstance?.presupuesto}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Presupuesto
                </div>
                
                <div class="col-md-4">
                    ${presupuestoInstance?.presupuesto?.encodeAsHTML()}
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${presupuestoInstance?.numero}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Numero
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${presupuestoInstance}" field="numero"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${presupuestoInstance?.descripcion}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Descripcion
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${presupuestoInstance}" field="descripcion"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${presupuestoInstance?.nivel}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Nivel
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${presupuestoInstance}" field="nivel"/>
                </div>
                
            </div>
        </g:if>
    
        <g:if test="${presupuestoInstance?.movimiento}">
            <div class="row">
                <div class="col-md-3 show-label">
                    Movimiento
                </div>
                
                <div class="col-md-4">
                    <g:fieldValue bean="${presupuestoInstance}" field="movimiento"/>
                </div>
                
            </div>
        </g:if>
    
    </div>
</g:else>