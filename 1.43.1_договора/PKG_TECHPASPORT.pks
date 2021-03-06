CREATE OR REPLACE package KURS3.pkg_techpasport is
--ilonis
--12.02.2013
-- ����� ��� ������ � ����������� ��������� �� ���������



--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :  ��������� ��� ������������� ����� ����� �� � ����������
  -- ���������:                                                                                                  
  -- �������:     
  -- ��������:  
procedure update_tp_relation_apart( p_apart_id_  number,  p_build_id_  number  ,p_apart_num_  number  ,p_apart_idx_  char,  iscommit in number  );

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ���������� ������ � �������� �� 
  -- ���������:                                                                                                  
  -- �������:     
  -- ��������:  
procedure update_techpasport_traffic( p_traffic_id_ in out number,
                                                        p_tp_id_   number,   
                                                        p_workplacelink_id_ number,
                                                        p_doc_num_      varchar2,
                                                        p_doc_date_      date, 
                                                        iscommit in number  );

--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :  ��������� ��� �������� ��� ��������� ������ �� ��
  -- ���������:                                                                                                  
  -- �������:     
  -- ��������:  
procedure update_techpasport( p_tp_id_  in out  number,   p_apart_id_    number,  p_source_id_   number,
                                              p_regnum_  varchar2,  p_regdate_  date,  p_inventnum_  varchar2,   iscommit in number  );
                                                        

--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :  ���������� ���������� 
  -- ���������:                                                                                                  
  -- �������:     
  -- ��������:  
procedure update_signer( p_t_doc_id_  number,   p_signt_id_    number,  p_operator_  varchar2,  p_dolgn_ varchar2,   iscommit in number  ) ;
                                                              
                                              
-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ���������� ��������� ��������
  -- ���������:                                                                                                  
  -- �������:     
  -- ��������:    
  -- code -��� ������   
procedure update_traffic_group( p_workplacelink_id_ number,
                                                p_doc_num_      varchar2,
                                                p_doc_date_      date, 
                                                p_list_code in number,
                                                p_list_num in number,
                                                isCommit in number,
                                                p_code in out number  );
                                                                                                    
                                                
-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   �������� ����������� ���������� ��������� ��������
  -- ���������:                                                                                                  
  -- �������:     
  -- ��������:    
  -- code -��� ������   
procedure check_traffic_group_operation(  p_list_code in number,
                                                             p_list_num in number,
                                                             p_code in out number,
                                                             p_m_code out varchar2
                                                              ) ;
                                                
                  
-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ��������� ��� ��������� ��������� �������� �����������
  -- ���������: 
  --    p_sender_id ����������� 
  --    p_taker_id   ����������
  -- �������:     
  -- ��������:       
  --    po_cdata   ������ � ��������
procedure get_datatraffictp (p_sender_id_ number,p_taker_id_ number:=0, po_cdata_ in out kurs3.curstype);


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :    ���������� id ����� ������ �� 132  
  -- ���������: 
    -- �������:     
  -- ��������:       
procedure get_workerplace(   p_wp_id_  in out number ) ;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ��������  ������ � �������� �� 
  -- ���������: 
    -- �������:     
  -- ��������:       
procedure delete_techpasport_traffic( p_traffic_id_  number,  iscommit in number  );

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ������� ������������� ��� ��������� ������ �������� �� ���� ������ � ���� �������� 
  -- ���������:  
    -- �������:
    --      p_build_id_  ��� ������,   
    --       p_a_id_    ��� �������� 
  -- ��������:         
  -- ����� �������  
 function apartment_techpasport ( p_build_id_ number := 0, p_a_id_ number, p_with_num_ number := 0) return varchar2; 
                                          
 -------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 22.02.2013
  -- �������� :   ������� ������������� ��� ��������� ������ �������� �� ���� ������ (��� ������ ��������) 
  -- ���������:  
    -- �������:
      --       p_a_id_    ��� �������� 
  -- ��������:         
  -- ����� �������  
function get_building_adress ( p_a_id_ number) return varchar2;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 22.02.2013
  -- �������� :   ������� ������������� ��� ��������� �� �������� ������������
  -- ���������:  
    -- �������:
  -- ��������:         
   -- ����������
function get_user_id  return number  ;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 22.02.2013
  -- �������� :   ������� ������������� ��� ��������� ���������� ������������  �� ������
  -- ���������:  
  -- �������:
  --       p_a_id_    ��� ��������      
  --      p_traffic_doc_id �� ���� ��������      
  -- ��������:         
  -- ����������
function get_aprt_count ( p_a_id_ number, p_traffic_doc_id number, p_work_place_link_id number ) return number;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 22.02.2013
  -- �������� :   ������� ������������� ��� ��������� ������� ������� �� ������ � ������� ���� �����������
  -- ���������:  
  -- �������:
  --       p_a_id_    ��� ��������  
  --      p_traffic_doc_id �� ���� ��������      
  -- ��������:         
  -- ������(������ ������� ����������� ',')  
function get_aprt_number ( p_a_id_ number, p_traffic_doc_id number, p_work_place_link_id number ) return varchar2 ;

 
 -------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ��������� ��� ��������� ����� �� �������������� ����������� � ����������� �� ���� �����
  -- ���������:  
    -- �������:
  -- ��������:         
procedure get_eanable_edit_tp (p_freespace_id_ number, p_isedit  out number, p_istrafficedit out number) ;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ������� ������������� ��� ��������� �������������� ���������� ��� ����������� ��������
  -- ���������:  
    -- �������:
  -- ��������:         
function get_techpasport_options ( p_wpid_ number) return varchar2;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 12.02.2013
  -- �������� :   ������� ������������� ��� ��������� ������ ���� �������� ��������
  -- ���������:  
   --  p_type_act_ ��� ����� (��. 134) 
    -- �������:
  -- ��������: 
  -- ����� ���� ����  --���/2013/10/01        
function  get_traffict_act_number ( p_type_act_ number) return varchar2;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 13.02.2013
  -- �������� :  ��������� ��� ��������� ��������� �����������  �� ������ ������ ��� �������������� �������
  -- ���������:  
   --  p_order_id_ ������������� �������
    -- �������:
  -- ��������:
  --  po_cData  �������� �����������
 procedure get_data_techpasport (p_order_id_ number, po_cdata  out kurs3.curstype) ;

                  
-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 13.02.2013
  -- �������� :  ��������� �������� �����������  ����������
  -- ���������:  
  --    p_tp_id_         �� - �����������
  --    p_doc_num_    -����� ��������� ��������     
  --    p_date_num_   ���� ��������� ��������
  -- �������:
  -- ��������:
  --    po_code_    --������� 0-��� ��, -1 ��� ��, -2 �� ����� ��������, -3  �� �� �� �����,  -4 ������ ������ 
 procedure update_tp_from_rd ( p_tp_id_ in number, p_doc_num_ in varchar2, p_date_num_ in date, po_code_  out number);
 
 
 -------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 13.02.2013
  -- �������� :  �������� �������� �����������  (��������� �� � ����������� �������� ���)
  -- ���������:  
  --    p_tp_id_         �� - �����������
  -- �������:
  -- ��������:
  --    po_code_    --������� 0-��� ��, -1 ��� ��, -2 �� �� � ���������� , -3  ������ ������ 
procedure delete_tp_from_rd ( p_tp_id_ in number, po_code_  out number);
 

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- ���� �������� : 13.02.2013
  -- �������� :   ������� �������������  ������������� v_hausing_lists (������� ������� �����������) 1- ��, 2-���  �� 8 �����������
  -- ���������:  
  -- �������:    
  --     p_apart_id_ ������������� ���������  
  -- ��������: 
  -- 1- ��, 2-���      
function get_techpasport_exists ( p_apart_id_ number ) return number ;


end pkg_techpasport;
/