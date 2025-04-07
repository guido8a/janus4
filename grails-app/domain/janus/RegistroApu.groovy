package janus

import seguridad.Persona

class RegistroApu {

    Persona persona
    String rbrotitl
    String cldatitl
    String rbro
    int prefijo
    String cldarbro
    String rbronmbr
    String titlEq
    String cldaEq
    String cdgoEq
    String nmbrEq
    String cntdEq
    String trfaEq
    String pcunEq
    String rndmEq
    String cstoEq
    String titlMo
    String cldaMo
    String cdgoMo
    String nmbrMo
    String cntdMo
    String trfaMo
    String pcunMo
    String rndmMo
    String cstoMo
    String titlMt
    String cldaMt
    String cdgoMt
    String nmbrMt
    String unddMt
    String cntdMt
    String pcunMt
    String cstoMt
    String titlTr
    String cldaTr
    String cdgoTr
    String nmbrTr
    String unddTr
    String pesoTr
    String cntdTr
    String dstnTr
    String pcunTr
    String cstoTr
    String nombre

    static auditable = true
    static mapping = {
        table 'rgap'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'rgap__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'rgap__id'
            persona column: 'prsn__id'
            rbrotitl column: 'rgaptitl'
            cldatitl column: 'rgapcdti'
            rbro column: 'rgaprbro'
            prefijo column: 'rgappref'
            cldarbro column: 'rgapcdrb'
            rbronmbr column: 'rgaprbnm'
            titlEq column: 'rgaptieq'
            cldaEq column: 'rgapcdeq'
            cdgoEq column: 'rgapcoeq'
            nmbrEq column: 'rgapnmeq'
            cntdEq column: 'rgapcneq'
            trfaEq column: 'rgaptreq'
            pcunEq column: 'rgappceq'
            rndmEq column: 'rgaprdeq'
            cstoEq column: 'rgapcteq'
            titlMo column: 'rgaptimo'
            cldaMo column: 'rgapcdmo'
            cdgoMo column: 'rgapcomo'
            nmbrMo column: 'rgapnmmo'
            cntdMo column: 'rgapcnmo'
            trfaMo column: 'rgaptrmo'
            pcunMo column: 'rgappcmo'
            rndmMo column: 'rgaprdmo'
            cstoMo column: 'rgapctmo'
            titlMt column: 'rgaptimt'
            cldaMt column: 'rgapcdmt'
            cdgoMt column: 'rgapcomt'
            nmbrMt column: 'rgapnmmt'
            unddMt column: 'rgapunmt'
            cntdMt column: 'rgapcnmt'
            pcunMt column: 'rgappcmt'
            cstoMt column: 'rgapctmt'
            titlTr column: 'rgaptitr'
            cldaTr column: 'rgapcdtr'
            cdgoTr column: 'rgapcotr'
            nmbrTr column: 'rgapnmtr'
            unddTr column: 'rgapuntr'
            pesoTr column: 'rgappetr'
            cntdTr column: 'rgapcntr'
            dstnTr column: 'rgapdstr'
            pcunTr column: 'rgappctr'
            cstoTr column: 'rgapcttr'
            nombre column: 'rgapnmbr'

        }
    }
    static constraints = {
        persona(blank: false, nullable: false)
        rbrotitl(blank: true, nullable: true)
        cldatitl(blank: true, nullable: true)
        rbro(blank: true, nullable: true)
        prefijo(blank: true, nullable: true)
        cldarbro(blank: true, nullable: true)
        rbronmbr(blank: true, nullable: true)
        titlEq(blank: true, nullable: true)
        cldaEq(blank: true, nullable: true)
        cdgoEq(blank: true, nullable: true)
        nmbrEq(blank: true, nullable: true)
        cntdEq(blank: true, nullable: true)
        trfaEq(blank: true, nullable: true)
        pcunEq(blank: true, nullable: true)
        rndmEq(blank: true, nullable: true)
        cstoEq(blank: true, nullable: true)
        titlMo(blank: true, nullable: true)
        cldaMo(blank: true, nullable: true)
        cdgoMo(blank: true, nullable: true)
        nmbrMo(blank: true, nullable: true)
        cntdMo(blank: true, nullable: true)
        trfaMo(blank: true, nullable: true)
        pcunMo(blank: true, nullable: true)
        rndmMo(blank: true, nullable: true)
        cstoMo(blank: true, nullable: true)
        titlMt(blank: true, nullable: true)
        cldaMt(blank: true, nullable: true)
        cdgoMt(blank: true, nullable: true)
        nmbrMt(blank: true, nullable: true)
        unddMt(blank: true, nullable: true)
        cntdMt(blank: true, nullable: true)
        pcunMt(blank: true, nullable: true)
        cstoMt(blank: true, nullable: true)
        titlTr(blank: true, nullable: true)
        cldaTr(blank: true, nullable: true)
        cdgoTr(blank: true, nullable: true)
        nmbrTr(blank: true, nullable: true)
        unddTr(blank: true, nullable: true)
        pesoTr(blank: true, nullable: true)
        cntdTr(blank: true, nullable: true)
        dstnTr(blank: true, nullable: true)
        pcunTr(blank: true, nullable: true)
        cstoTr(blank: true, nullable: true)
        nombre(blank: false, nullable: false)
    }
}
