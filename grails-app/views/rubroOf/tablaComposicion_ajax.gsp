<div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;float: left;width: 95%" id="tablas">
    <p class="css-vertical-text">Composición</p>

    <div class="linea" style="height: 98%;"></div>
    <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Equipo
            </th>
            <th style="width: 80px;">
                Cantidad
            </th>
            <th class="col_tarifa" style="display: none;">Tarifa <br>($/hora)</th>
            <th class="col_hora" style="display: none;">Costo($)</th>
            <th class="col_rend" style="width: 50px">Rendimiento</th>
            <th class="col_total" style="display: none;">C.Total($)<br>($/hora)</th>
            <th style="width: 40px" class="col_delete"></th>
        </tr>
        </thead>
        <tbody id="tabla_equipo">
        <g:if test="${equipos}">
            <g:each in="${equipos}" var="equipo" status="i">
            %{--            <g:if test="${rub.item.departamento.subgrupo.grupo.id == 3}">--}%
            %{--                <tr class="item_row" id="${rub.id}" data-item="${rub.item.id}" tipo="${rub.item.departamento.subgrupo.grupo.id}">--}%
            %{--                    <td class="cdgo">${rub.item.codigo}</td>--}%
            %{--                    <td>${rub.item.nombre}</td>--}%
            %{--                    <td style="text-align: right" class="cant">--}%
            %{--                        <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />--}%
            %{--                    </td>--}%
            %{--                    <td class="col_tarifa" style="display: none;text-align: right" id="i_${rub.item.id}" ></td>--}%
            %{--                    <td class="col_hora" style="display: none;text-align: right"></td>--}%
            %{--                    <td class="col_rend rend" style="width: 50px;text-align: right"  valor="${rub.rendimiento}">--}%
            %{--                        <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" />--}%
            %{--                    </td>--}%
            %{--                    <td class="col_total" style="display: none;text-align: right"></td>--}%
            %{--                    <td style="width: 70px;text-align: center" class="col_delete">--}%
            %{--                        <a class="btn btn-xs btn-success btnEditar" href="#" rel="tooltip" title="Editar" data-id="${rub.id}" data-item="${rub.item.id}"  data-tipo="${rub.item.departamento.subgrupo.grupo.id}"--}%
            %{--                           data-unidad="${rub.item.unidad.codigo}" data-codigo="${rub.item.codigo}" data-desc="${rub.item.nombre}" data-cant="${rub.cantidad}" data-rend="${rub.rendimiento}">--}%
            %{--                            <i class="fa fa-edit"></i>--}%
            %{--                        </a>--}%
            %{--                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}" data-id="${rub.id}">--}%
            %{--                            <i class="fa fa-trash"></i>--}%
            %{--                        </a>--}%
            %{--                    </td>--}%
            %{--                </tr>--}%
            %{--            </g:if>--}%
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning" colspan="5"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Mano de obra
            </th>
            <th style="width: 80px">
                Cantidad
            </th>

            <th class="col_jornal" style="display: none;"  >Jornal<br>($/hora)</th>
            <th class="col_hora" style="display: none;">Costo($)</th>
            <th class="col_rend" style="width: 50px;">Rendimiento</th>
            <th class="col_total" style="display: none;">C.Total($)</th>
            <th style="width: 40px" class="col_delete"></th>
        </tr>
        </thead>
        <tbody id="tabla_mano">
        <g:if test="${manos}">
            <g:each in="${manos}" var="mano" status="i">
            %{--            <g:if test="${rub.item.departamento.subgrupo.grupo.id == 2}">--}%
            %{--                <tr class="item_row" id="${rub.id}" data-item="${rub.item.id}" tipo="${rub.item.departamento.subgrupo.grupo.id}">--}%
            %{--                    <td class="cdgo">${rub.item.codigo}</td>--}%
            %{--                    <td>${rub.item.nombre}</td>--}%
            %{--                    <td style="text-align: right" class="cant">--}%
            %{--                        <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />--}%
            %{--                    </td>--}%

            %{--                    <td class="col_jornal" style="display: none;text-align: right" id="i_${rub.item.id}"></td>--}%
            %{--                    <td class="col_hora" style="display: none;text-align: right"></td>--}%
            %{--                    <td class="col_rend rend" style="width: 50px;text-align: right"  valor="${rub.rendimiento}">--}%
            %{--                        <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />--}%
            %{--                    </td>--}%
            %{--                    <td class="col_total" style="display: none;text-align: right"></td>--}%
            %{--                    <td style="width: 70px;text-align: center" class="col_delete">--}%
            %{--                        <a class="btn btn-xs btn-success btnEditar" href="#" rel="tooltip" title="Editar" data-id="${rub.id}" data-item="${rub.item.id}"  data-tipo="${rub.item.departamento.subgrupo.grupo.id}"--}%
            %{--                           data-unidad="${rub.item.unidad.codigo}" data-codigo="${rub.item.codigo}" data-desc="${rub.item.nombre}" data-cant="${rub.cantidad}" data-rend="${rub.rendimiento}">--}%
            %{--                            <i class="fa fa-edit"></i>--}%
            %{--                        </a>--}%
            %{--                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}" data-id="${rub.id}">--}%
            %{--                            <i class="fa fa-trash"></i></a>--}%
            %{--                    </td>--}%
            %{--                </tr>--}%
            %{--            </g:if>--}%
            </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center">
                <td class="alert alert-warning" colspan="5"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 600px;">
                Descripción Material
            </th>
            <th style="width: 60px" class="col_unidad">
                Unidad
            </th>
            <th style="width: 80px">
                Cantidad
            </th>
            <th style="width: 40px" class="col_delete"></th>
            <th class="col_precioUnit" style="display: none;">Unitario</th>
            <th class="col_vacio" style="width: 55px;display: none"></th>
            <th class="col_total" style="display: none;">C.Total($)</th>
            <th class="col_vacio" style="width: 55px;display: none"></th>
        </tr>
        </thead>
        <tbody id="tabla_material">
        <g:if test="${materiales}">
                <g:each in="${materiales}" var="material" status="i">
        %{--            <g:if test="${rub.item.departamento.subgrupo.grupo.id == 1}">--}%
        %{--                <tr class="item_row" id="${rub.id}" data-item="${rub.item.id}"  tipo="${rub.item.departamento.subgrupo.grupo.id}" data-tipo="${rub.item.departamento.subgrupo.grupo.id}" data-unidad="${rub.item.unidad.codigo}">--}%
        %{--                    <td class="cdgo">${rub.item.codigo}</td>--}%
        %{--                    <td>${rub.item.nombre}</td>--}%
        %{--                    <td style="width: 60px !important;text-align: center" class="col_unidad">${rub.item.unidad.codigo}</td>--}%
        %{--                    <td style="text-align: right" class="cant">--}%
        %{--                        <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />--}%
        %{--                    </td>--}%
        %{--                    <td class="col_vacio" style="width: 50px;display: none;"></td>--}%
        %{--                    <td class="col_precioUnit" style="display: none;text-align: right" id="i_${rub.item.id}"></td>--}%
        %{--                    <td class="col_vacio" style="width: 50px;display: none"></td>--}%
        %{--                    <td class="col_total" style="display: none;text-align: right"></td>--}%
        %{--                    <td style="width: 70px;text-align: center" class="col_delete">--}%
        %{--                        <a class="btn btn-xs btn-success btnEditar" href="#" rel="tooltip" title="Editar" data-id="${rub.id}" data-item="${rub.item.id}"  data-tipo="${rub.item.departamento.subgrupo.grupo.id}"--}%
        %{--                           data-unidad="${rub.item.unidad.codigo}" data-codigo="${rub.item.codigo}" data-desc="${rub.item.nombre}" data-cant="${rub.cantidad}" data-rend="${1}">--}%
        %{--                            <i class="fa fa-edit"></i>--}%
        %{--                        </a>--}%
        %{--                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar material" iden="${rub.id}" data-id="${rub.id}">--}%
        %{--                            <i class="fa fa-trash"></i></a>--}%
        %{--                    </td>--}%
        %{--                </tr>--}%
        %{--            </g:if>--}%
                </g:each>
        </g:if>
        <g:else>
            <tr style="text-align: center" >
                <td class="alert alert-warning" colspan="5"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> No existen registros </strong></td>
            </tr>
        </g:else>
        </tbody>
    </table>
    <div id="tabla_transporte"></div>
    <div id="tabla_indi"></div>
    <div id="tabla_costos" style="height: 120px;display: none;float: right;width: 100%;margin-bottom: 10px;"></div>
</div>