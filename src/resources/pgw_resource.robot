*** Settings ***
Library                             OperatingSystem
*** Variables ***
${srs_ip} =                         ETH0
${pgw_ip} =                         PGW_IP
${IMSI} =                           IMSI
${s6bIMSI} =                        S6BIMSi
${pcoIMSI} =                        PCOIMSI
${mcc} =                            MCC
${mnc} =                            MNC
${apn} =                            internet
${imsapn} =                         ims
${wrongapn} =                       ${10}
${interface} =                      lo
${csrseq} =                         ${5667214}
${csrseqfail_IMSI}=                 ${5667218}
${csrseqfail_paa} =                 ${5667216}
${csrseqfail_apn} =                 ${5667213}
${s6bseq} =                         ${5667220}
${imsseq} =                         ${5667225}
${pcocsrseq} =                      ${5667254}
${csrrattype} =                     ${6}
${s6brattype} =                     ${3}
${csrinterfacetype} =               ${6}
${s6binterfacetype} =               ${30}
${bearercsrrattype} =               ${4}
${s6bbearerinterfacetype} =         ${31}
${csrinstance} =                    ${2}  
${s6binstance} =                    ${5}
${csrport} =                        ${2123}
${gtpuport} =                       ${2152}
${internetepi} =                    ${5}
${imsepi} =                         ${6}
${internetqci} =                    ${9}
${imsqci} =                         ${5}
${deletesessionseq} =               ${5667216}
${s6bdeletesessionseq} =            ${5667217}
${imsdeletesessionseq} =            ${5667218}
${paadress} =                       0.0.0.0
${ie_cause}=                        Set Variable    ${EMPTY}
${ip_address}=                      Set Variable    ${EMPTY}
${gre_key}=                         Set Variable    ${EMPTY}
${s6b_ip_address}=                  Set Variable    ${EMPTY}
${pgwu_ipaddress}=                  Set Variable    ${EMPTY}
${pgwu_gre_key}=                    Set Variable    ${EMPTY}
${s6b_gre_key}=                     Set Variable    ${EMPTY}
${ims_ip_address}=                  Set Variable    ${EMPTY}
${ims_gre_key}=                     Set Variable    ${EMPTY}
${cause}=                           Set Variable    ${EMPTY}
${modifiy_sess_gre_key}=            Set Variable    ${EMPTY}                  
${socket} =                         Set Variable    ${EMPTY}
${gtpu_socket} =                    Set Variable    ${EMPTY}
${cbreq} =                          Set Variable    ${EMPTY}   
${cbreq_base_pkt} =                 Set Variable    ${EMPTY}
${dbreq} =                          Set Variable    ${EMPTY}   
${dbreq_base_pkt} =                 Set Variable    ${EMPTY}
${pco_mtu}=                         Set Variable    ${EMPTY}
*** Keywords ***
Set GTP Socket
    [Arguments]                     ${socket}              
    ${socket} =                     Set Variable    ${socket}   
    Set Suite Variable              ${socket}
Set GTPU Socket
    [Arguments]                     ${gtpu_socket}             
    ${gtpu_socket}=                 Set Variable    ${gtpu_socket}   
    Set Suite Variable              ${gtpu_socket}
Validate Response
    [Arguments]                     ${response}
    Should Not Be Equal As Strings  ${response}  None     
    Should Not Be Equal As Strings  ${response}  0.0.0.0  


Validate MTU Response
    [Arguments]                     ${response}
    Should Be True                  ${response} >= 1400 and ${response} <= 1500  response value is out of range 

Validate Failed Response
    [Arguments]                     ${response}
    Should Not Be Equal As Strings  ${response}  None     
    Should Not Be Equal As Strings  ${response}  18 
    Should Not Be Equal As Strings  ${response}  16 
Validate Ping Response
    [Arguments]                      ${response}
    ${expected_value2}               Set Variable    ${response[0]}
    ${expected_value}                Set Variable    ${response[1]}
    Should Contain                   ${expected_value2}      GTP_U_Header
    Should Be Equal                  ${expected_value}       ${0}
Set IPAddress and GREID
    [Arguments]                     ${finalresult}
    ${ie_cause}=                    Set Variable    ${finalresult[0]}
    ${ip_address}=                  Set Variable    ${finalresult[1]}
    ${gre_key}=                     Set Variable    ${finalresult[2]}
    ${pgwu_ipaddress}=              Set Variable    ${finalresult[3]} 
    ${pgwu_gre_key}=                Set Variable    ${finalresult[4]}  
    Set Suite Variable              ${ie_cause}                 
    Set Suite Variable              ${ip_address}    
    Set Suite Variable              ${gre_key}
    Set Suite Variable              ${pgwu_ipaddress}
    Set Suite Variable              ${pgwu_gre_key}
Set IMS IPAddress and GREID
    [Arguments]                     ${finalresult}
    ${ims_ip_address}=              Set Variable    ${finalresult[1]}
    ${ims_gre_key}=                 Set Variable    ${finalresult[2]}
    Set Suite Variable              ${ims_ip_address}    
    Set Suite Variable              ${ims_gre_key}

Set MTU
    [Arguments]                     ${finalresult}
    ${pco_mtu}=                     Set Variable    ${finalresult[5]}
    Set Suite Variable              ${pco_mtu}    

Set s6bIPAddress and s6bGREID
    [Arguments]                     ${finalresult}
    ${s6b_ip_address}=              Set Variable    ${finalresult[1]}
    ${s6b_gre_key}=                 Set Variable    ${finalresult[2]}
    Set Suite Variable              ${s6b_ip_address}    
    Set Suite Variable              ${s6b_gre_key}
    
Set Cause and modify GREID
    [Arguments]                     ${finalresult}
    ${cause}=                       Set Variable    ${finalresult[0]}
    ${modifiy_sess_gre_key}=        Set Variable    ${finalresult[1]}
    Set Suite Variable              ${cause}    
    Set Suite Variable              ${modifiy_sess_gre_key}
Validate Cause
    [Arguments]                    ${response}
    Should Be Equal                ${response}  ${16}     
Validate CB GTP Request
    [Arguments]                    ${response}
    ${expected_value}              Set Variable    GTPV2CreateBearerRequest
    Should Contain                 ${response}     ${expected_value}   
Validate DB GTP Request
    [Arguments]                    ${response}
    ${expected_value}              Set Variable    GTPV2DeleteBearerRequest
    Should Contain                 ${response}     ${expected_value} 
Validate No Response
    [Arguments]                    ${response}
    Should Be Equal                ${response}  ${None}  

Set CBreq and CBRes_base_pkt
    [Arguments]                     ${result}
    ${cbreq}=                       Set Variable    ${result[0]}
    ${cbreq_base_pkt}=              Set Variable    ${result[1]}
    Set Suite Variable              ${cbreq}    
    Set Suite Variable              ${cbreq_base_pkt}

Set DBreq and DBRes_base_pkt
    [Arguments]                     ${result}
    ${dbreq}=                       Set Variable    ${result[0]}
    ${dbreq_base_pkt}=              Set Variable    ${result[1]}
    Set Suite Variable              ${dbreq}    
    Set Suite Variable              ${dbreq_base_pkt}