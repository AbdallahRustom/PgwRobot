*** Settings ***
Resource          resources/pgw_resource.robot
Library           python/gtppacket.py
Library           python/mydiameterscript.py
*** Test Cases ***
My Initilization 
    [Documentation]                Inializing Clients   
    [Tags]                         First    Second    Third     Forth    Fifth    Six    Seven    Eighth                
    establish_diam_tcp_connection 
    ${socket} =                    init_soc     
    Set GTP Socket                 ${socket}
    Sleep                          5s
My First Test
    [Documentation]                Send Create Session Request 
    [Tags]                         First
    ${base_pkt} =                  create_session_request    ${srs_ip}   ${IMSI}      ${mcc}      ${mnc}      ${apn}    ${csrrattype}   ${csrinterfacetype}    ${bearercsrrattype}    ${csrinstance}    ${csrseq}  ${internetepi}     ${internetqci}     ${paadress} 
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}   ${csrport}  ${base_pkt}    
    ${response} =                  get_gtp_response          ${socket}
    Set IPAddress and GREID        ${response}
    Log To Console                 ${ip_address} 
    Validate Response              ${ip_address}
    Sleep                          5s
My Second Test
    [Documentation]                Validate Dataplane request send Ping request
    [Tags]                         Second
    ${base_pkt} =                  gtp_ping                  ${pgwu_gre_key}  ${ip_address}   ${srs_ip}
    ${gtpu_socket} =               init_gtpu_soc             ${srs_ip}      
    Set GTPU Socket                ${gtpu_socket}
    ${request} =                   send_gtpv2_message        ${gtpu_socket}   ${pgwu_ipaddress}    ${gtpuport}    ${base_pkt}    
    ${response} =                  get_gtpu_response         ${gtpu_socket}
    Log To Console                 ${response}
    Validate Ping Response         ${response}
    Sleep                          5s
My Third Test
    [Documentation]                Testing S6b interface 
    [Tags]                         Third
    ${base_pkt} =                  create_session_request    ${srs_ip}    ${s6bIMSI}     ${mcc}      ${mnc}      ${apn}    ${s6brattype}   ${s6binterfacetype}   ${s6bbearerinterfacetype}    ${s6binstance}     ${s6bseq}  ${internetepi}    ${internetqci}    ${paadress} 
    ${request} =                   send_gtpv2_message        ${socket}      ${pgw_ip}   ${csrport}  ${base_pkt}   
    ${response} =                  get_gtp_response          ${socket}
    Set s6bIPAddress and s6bGREID  ${response}
    Log To Console                 ${s6b_ip_address}
    Validate Response              ${s6b_ip_address}
    Sleep                          5s
My Forth Test
    [Documentation]                Send IMS Create Session Request 
    [Tags]                         Forth
    ${base_pkt} =                  create_session_request    ${srs_ip}    ${IMSI}     ${mcc}      ${mnc}      ${imsapn}    ${csrrattype}   ${csrinterfacetype}    ${bearercsrrattype}    ${csrinstance}    ${imsseq}   ${imsepi}    ${imsqci}   ${paadress} 
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}   ${csrport}  ${base_pkt}    
    ${response} =                  get_gtp_response          ${socket}
    Set IMS IPAddress and GREID    ${response}
    Log To Console                 ${ims_ip_address}
    Validate Response              ${ims_ip_address}
    Sleep                          5s
My Fifth Test
    [Documentation]                Testing Modify bearer Request  
    [Tags]                         Fifth
    ${base_pkt} =                  modify_bearer_request    ${gre_key}  
    ${request} =                   send_gtpv2_message       ${socket}       ${pgw_ip}   ${csrport}   ${base_pkt}
    ${response} =                  get_gtp_response         ${socket}    
     Log To Console                 ${response}    
    Set Cause and modify GREID     ${response}
    Log To Console                 ${cause}               
    Validate Cause                 ${cause}
    Sleep                          5s
My Sixth Test
    [Documentation]                Testing Create Bearer Request  
    [Tags]                         Six
    send_auth_request
    ${result}=                     get_gtp_response    ${socket}     
    Set CBreq and CBRes_base_pkt   ${result}
    Log To Console                 ${cbreq}
    Validate CB GTP Request        ${cbreq}
    send_gtpv2_message             ${socket}    ${pgw_ip}    ${csrport}    ${cbreq_base_pkt}      
    Sleep                          5s
My Seventh Test
    [Documentation]                Testing Delete Bearer Request  
    [Tags]                         Seven
    send_delete_auth_request
    ${result}=                     get_gtp_response    ${socket}
    Set DBreq and DBRes_base_pkt   ${result}
    Log To Console                 ${dbreq} 
    Validate DB GTP Request        ${dbreq}
    send_gtpv2_message             ${socket}    ${pgw_ip}    ${csrport}    ${dbreq_base_pkt}   
    Sleep                          5s
My Eighth Test
    [Documentation]                Testing Delete session Request  
    [Tags]                         Eight
    ${base_pkt} =                  delete_session_request    ${mcc}      ${mnc}       ${gre_key}     ${deletesessionseq}    ${internetepi}    
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}    ${csrport}     ${base_pkt}
    ${cause} =                     get_gtp_response          ${socket}    
    Log To Console                 ${cause}
    Validate Cause                 ${cause}
     #${base_pkt} =                  delete_session_request    ${mcc}      ${mnc}       ${s6b_gre_key}  ${s6bdeletesessionseq}  ${internetepi}   
     #${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}    ${csrport}      ${base_pkt}
    ${base_pkt} =                  delete_session_request    ${mcc}      ${mnc}       ${ims_gre_key}  ${imsdeletesessionseq}  ${imsqci} 
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}    ${csrport}      ${base_pkt}
    Sleep                          5s
My Ninth Test
    [Documentation]                Send Create Session Request Without IMSI IE
    [Tags]                         Ninth
    ${base_pkt} =                  create_session_request    ${srs_ip}   0      ${mcc}      ${mnc}      ${apn}    ${csrrattype}   ${csrinterfacetype}    ${bearercsrrattype}    ${csrinstance}    ${csrseqfail_IMSI}  ${internetepi}     ${internetqci}     ${paadress} 
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}   ${csrport}  ${base_pkt}    
    ${response} =                  get_gtp_response          ${socket}
    Set IPAddress and GREID        ${response}
    Log To Console                 ${ie_cause}
    Validate Failed Response       ${ie_cause}
    Sleep                          5s
My Tenth Test
    [Documentation]                Send Create Session Request Without paa address
    [Tags]                         Tenth
    ${base_pkt} =                  create_session_request    ${srs_ip}   ${IMSI}      ${mcc}      ${mnc}      ${apn}    ${csrrattype}   ${csrinterfacetype}    ${bearercsrrattype}    ${csrinstance}    ${csrseqfail_paa}  ${internetepi}     ${internetqci}     0 
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}   ${csrport}  ${base_pkt}    
    ${response} =                  get_gtp_response          ${socket}
    Set IPAddress and GREID        ${response}
    Log To Console                 ${ie_cause}
    Validate Failed Response       ${ie_cause}
    Sleep                          5s
My Eleventh Test
    [Documentation]                Send Create Session Request With wrong apn
    [Tags]                         Eleventh
    ${base_pkt} =                  create_session_request    ${srs_ip}   ${IMSI}      ${mcc}      ${mnc}      ${wrongapn}    ${csrrattype}   ${csrinterfacetype}    ${bearercsrrattype}    ${csrinstance}    ${csrseqfail_apn}  ${internetepi}     ${internetqci}     ${paadress} 
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}   ${csrport}  ${base_pkt}    
    ${response} =                  get_gtp_response          ${socket}
    Validate No Response           ${response}
    Sleep                          5s
My Twelfth Test
    [Documentation]                Send Create Session Request with PCO
    [Tags]                         Twelfth
    ${base_pkt} =                  create_session_request    ${srs_ip}   ${IMSI}     ${mcc}      ${mnc}      ${apn}    ${csrrattype}   ${csrinterfacetype}    ${bearercsrrattype}    ${csrinstance}    ${pcocsrseq}  ${internetepi}     ${internetqci}     ${paadress} 
    ${pco_base_pkt} =              ie_add_pco    ${base_pkt}
    ${request} =                   send_gtpv2_message        ${socket}   ${pgw_ip}   ${csrport}  ${pco_base_pkt}    
    ${response} =                  get_gtp_response          ${socket}
    Set MTU                        ${response}
    Log To Console                 ${pco_mtu} 
    Validate MTU Response          ${pco_mtu} 
    Sleep                          5s      
My Thirteenth Test 
    [Documentation]                Closing Clients
    [Tags]                         First    Second    Third     Forth    Fifth    Six    Seven    Eighth    Ninth   Tenth    Eleventh     Twelfth    Thirteenth
    close_tcp_session