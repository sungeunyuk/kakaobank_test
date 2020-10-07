

/*
문제 3. 고객에 대한 분석을 용이하게 하기 위해 고객별 요약 데이터 셋을 생성하고자 함.

*/

use KAKAOBANK;

SHOW TABLE STATUS LIKE 'KAKAOBANK.MENU_LOG';
SHOW TABLE STATUS LIKE 'KAKAOBANK.USR_INFO_CHG_LOG';

SHOW INDEX FROM KAKAOBANK.MENU_LOG;
SHOW INDEX FROM KAKAOBANK.USR_INFO_CHG_LOG;

-- // 파티션을 사용하지 않는 일반 테이블의 통계 정보 수집
ANALYZE TABLE KAKAOBANK.MENU_LOG;
ANALYZE TABLE KAKAOBANK.USR_INFO_CHG_LOG;


CREATE INDEX IDX_MENU_LOG_MENU_NAME ON KAKAOBANK.MENU_LOG (MENU_NM);
CREATE INDEX IDX_USR_INFO_CHG_LOG_LOC_NM ON KAKAOBANK.USR_INFO_CHG_LOG (loc_nm);


-- PRIMARY KEY (LOG_TKTM, LOG_ID)v
-- EXPLAIN FORMAT=JSON

 EXPLAIN FORMAT=JSON
 select a.usr_no  as '사용자 번호',
		case when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '1' then '남'
             when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '2' then '여'
             when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '3' then '남'
             when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '4' then '여'
             else '-'
             end as '성별',
        ifnull (floor(( cast(20200626 as unsigned) -
			   cast(concat( case when substr(rsdt_no , length(join_dt) +1 + 6, 1) in ('1','2')
								 then '19' else '20' end , substr(rsdt_no , length(join_dt) +1 , 6 ) ) as unsigned ) ) / 10000 ) , '-') as '나이' ,

        ifnull(b.loc_nm ,'-') as '지역명',
        ifnull(b.before_loc_nm ,'-')as '이전 지역명' ,
        ifnull(substr(mcco_nm , length(join_dt) +1, length(mcco_nm)) ,'-')as '이동통신사명' ,
		ifnull(substr(join_dt , 1,8) ,'-')as '가입일' ,
        ifnull(d.menu_nm ,'-')as '최빈메뉴',
        ifnull(c.menu_nm ,'-')as '최근메뉴'

from (
	select usr_no ,
		   min(LOG_TKTM) as join_dt  ,
		   max(if( length(rsdt_no) > 0 , concat(log_tktm , rsdt_no) , null )) as rsdt_no ,
		   max(if( length(mcco_nm) > 0 , concat(log_tktm , mcco_nm) , null )) as mcco_nm
	from KAKAOBANK.USR_INFO_CHG_LOG
	-- where usr_no = 003
	group by 1
) a
left outer join
(
-- 이전 지역 구하기위해
select usr_no ,
	   loc_nm ,
       lag(loc_nm) over(partition by usr_no order by LOG_TKTM) as before_loc_nm ,
       row_number() over ( partition by usr_no order by Log_tktm desc ) as rn
from KAKAOBANK.USR_INFO_CHG_LOG
where loc_nm is not null and loc_nm <> ''
) b
on a.usr_no = b.usr_no
and b.rn = 1
left outer join (
-- 최근 메뉴
select usr_no , menu_nm
from (
	select usr_no ,
		   LOG_TKTM ,
           menu_nm ,
           row_number() over(partition by usr_no order by LOG_TKTM desc) rn
	from KAKAOBANK.MENU_LOG a
    where menu_nm not in ('login' ,'logout')
) a
where rn = 1
) c
on a.usr_no = c.usr_no

left outer join
(
select usr_no , menu_nm , cnt , row_number() over (partition by usr_no  order by cnt desc) rnk
from (
select usr_no , menu_nm , count(*) cnt
	from KAKAOBANK.MENU_LOG a
    where menu_nm not in ('login' ,'logout')
    group by 1,2
    ) a
) d
on a.usr_no = d.usr_no
and d.rnk = 1
order by a.usr_no asc
;



-- 쿼리 수정

select  a.usr_no  as '사용자 번호',
        case when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '1' then '남'
        when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '2' then '여'
        when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '3' then '남'
        when substr(rsdt_no , length(join_dt) +1 + 6, 1) = '4' then '여'
        else '-'
        end as '성별',
        ifnull (floor(( cast(20200626 as unsigned) -
        cast(concat( case when substr(rsdt_no , length(join_dt) +1 + 6, 1) in ('1','2')
        then '19' else '20' end , substr(rsdt_no , length(join_dt) +1 , 6 ) ) as unsigned ) ) / 10000 ) , '-') as '나이' ,

        ifnull(b.loc_nm ,'-') as '지역명',
        ifnull(b.before_loc_nm ,'-')as '이전 지역명' ,
        ifnull(substr(mcco_nm , length(join_dt) +1, length(mcco_nm)) ,'-')as '이동통신사명' ,
        ifnull(substr(join_dt , 1,8) ,'-')as '가입일' ,
        ifnull(c.top_menu ,'-')as '최빈메뉴',
        ifnull(c.lst_menu ,'-')as '최근메뉴'
from (
    -- 메인이 되는 테이블 20190305022554
    select  usr_no ,
            min(LOG_TKTM) as join_dt  ,
            max(if( length(rsdt_no) > 0 , concat(log_tktm , rsdt_no) , null )) as rsdt_no ,
            max(if( length(mcco_nm) > 0 , concat(log_tktm , mcco_nm) , null )) as mcco_nm
    from KAKAOBANK.USR_INFO_CHG_LOG
    group by 1
) a
left outer join
(
-- 이전 지역 구하기위해
select  usr_no ,
        loc_nm ,
        lag(loc_nm) over(partition by usr_no order by LOG_TKTM) as before_loc_nm ,
        row_number() over ( partition by usr_no order by Log_tktm desc ) as rn
from KAKAOBANK.USR_INFO_CHG_LOG
where loc_nm is not null and loc_nm <> ''
) b
on a.usr_no = b.usr_no
and b.rn = 1
left outer join
(
-- 최근 메뉴 최빈 메뉴 추출
select usr_no , menu_nm as top_menu , substr(tt_menu_nm ,15 , 200) as lst_menu
from (
    select usr_no , menu_nm , cnt , tt_menu_nm , row_number() over (partition by usr_no order by cnt desc) rn
    from (
        select usr_no , menu_nm , count(*) as cnt , max(tt_menu_nm)  tt_menu_nm
        from (
            select usr_no , MENU_NM ,   max(concat(log_tktm , menu_nm)) over(partition by usr_no)  as tt_menu_nm
            from KAKAOBANK.MENU_LOG a
            where menu_nm not in ('login' , 'logout')
        ) a
    group by 1,2
    ) a
) a
where rn = 1
) c
on a.usr_no = c.usr_no
order by a.usr_no asc
;



-- 최근 메뉴 / 최빈 메뉴 쿼리 수정
-- left outer join 과다 사용 (테이블 데이터가 커지면 문제 발생)

-- 따라서, 이용자 테이블을 따로 dw 1차 dw 2차 테이블 등으로 분리 설계하여 처리
-- 이용자 이력 --> 이용자 마스터 테이블 (누적)
--  이용자_마스터 테이블 설계 (중간 작업으로 처리)
-- usr_no
-- 가입일(로그 최초 시간)
-- 최종 접속일( 로그 최종 마지막 시간)
-- 최종 지역 ( 이용자 이력 테이블에 지역 변경사항 등록되면 업데이트 반영)
-- 이전 지역 ( 업데이트 반영 시점에 최종 -> 이전지역 으로 데이터 업데이트 반영)
-- 나이 / 만나이 계산
-- 이동 통신사





/*
실행계획
id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1','PRIMARY','<derived2>',NULL,'ALL',NULL,NULL,NULL,NULL,'40','100.00','Using filesort'
'1','PRIMARY','<derived3>',NULL,'ref','<auto_key0>','<auto_key0>','51','a.usr_no,const','2','100.00',NULL
'1','PRIMARY','<derived5>',NULL,'ref','<auto_key0>','<auto_key0>','51','a.usr_no,const','10','100.00',NULL
'1','PRIMARY','<derived6>',NULL,'ref','<auto_key0>','<auto_key0>','51','a.usr_no,const','10','100.00',NULL
'6','DERIVED','<derived7>',NULL,'ALL',NULL,NULL,NULL,NULL,'415','100.00','Using filesort'
'7','DERIVED','a',NULL,'ALL','IDX_MENU_LOG_MENU_NAME',NULL,NULL,NULL,'649','63.94','Using where; Using temporary'
'5','DERIVED','a',NULL,'ALL','IDX_MENU_LOG_MENU_NAME',NULL,NULL,NULL,'649','63.94','Using where; Using filesort'
'3','DERIVED','USR_INFO_CHG_LOG',NULL,'ALL','IDX_USR_INFO_CHG_LOG_LOC_NM',NULL,NULL,NULL,'40','67.50','Using where; Using filesort'
'2','DERIVED','USR_INFO_CHG_LOG',NULL,'ALL',NULL,NULL,NULL,NULL,'40','100.00','Using temporary'

{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "15365.19"
    },
    "ordering_operation": {
      "using_filesort": true,
      "cost_info": {
        "sort_cost": "11065.02"
      },
      "nested_loop": [
        {
          "table": {
            "table_name": "a",
            "access_type": "ALL",
            "rows_examined_per_scan": 40,
            "rows_produced_per_join": 40,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "3.00",
              "eval_cost": "4.00",
              "prefix_cost": "7.00",
              "data_read_per_join": "65K"
            },
            "used_columns": [
              "usr_no",
              "join_dt",
              "rsdt_no",
              "mcco_nm"
            ],
            "materialized_from_subquery": {
              "using_temporary_table": true,
              "dependent": false,
              "cacheable": true,
              "query_block": {
                "select_id": 2,
                "cost_info": {
                  "query_cost": "4.25"
                },
                "grouping_operation": {
                  "using_temporary_table": true,
                  "using_filesort": false,
                  "table": {
                    "table_name": "USR_INFO_CHG_LOG",
                    "access_type": "ALL",
                    "rows_examined_per_scan": 40,
                    "rows_produced_per_join": 40,
                    "filtered": "100.00",
                    "cost_info": {
                      "read_cost": "0.25",
                      "eval_cost": "4.00",
                      "prefix_cost": "4.25",
                      "data_read_per_join": "19K"
                    },
                    "used_columns": [
                      "LOG_TKTM",
                      "LOG_ID",
                      "USR_NO",
                      "RSDT_NO",
                      "MCCO_NM"
                    ]
                  }
                }
              }
            }
          }
        },
        {
          "table": {
            "table_name": "b",
            "access_type": "ref",
            "possible_keys": [
              "<auto_key0>"
            ],
            "key": "<auto_key0>",
            "used_key_parts": [
              "usr_no",
              "rn"
            ],
            "key_length": "51",
            "ref": [
              "a.usr_no",
              "const"
            ],
            "rows_examined_per_scan": 2,
            "rows_produced_per_join": 108,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "27.00",
              "eval_cost": "10.80",
              "prefix_cost": "44.80",
              "data_read_per_join": "15K"
            },
            "used_columns": [
              "usr_no",
              "loc_nm",
              "before_loc_nm",
              "rn"
            ],
            "materialized_from_subquery": {
              "using_temporary_table": true,
              "dependent": false,
              "cacheable": true,
              "query_block": {
                "select_id": 3,
                "cost_info": {
                  "query_cost": "58.25"
                },
                "windowing": {
                  "windows": [
                    {
                      "name": "<unnamed window>",
                      "definition_position": 1,
                      "using_temporary_table": true,
                      "using_filesort": true,
                      "filesort_key": [
                        "`USR_NO`",
                        "`LOG_TKTM`"
                      ],
                      "frame_buffer": {
                        "using_temporary_table": true,
                        "optimized_frame_evaluation": true
                      },
                      "functions": [
                        "lag"
                      ]
                    },
                    {
                      "name": "<unnamed window>",
                      "definition_position": 2,
                      "last_executed_window": true,
                      "using_filesort": true,
                      "filesort_key": [
                        "`USR_NO`",
                        "`LOG_TKTM` desc"
                      ],
                      "functions": [
                        "row_number"
                      ]
                    }
                  ],
                  "cost_info": {
                    "sort_cost": "54.00"
                  },
                  "table": {
                    "table_name": "USR_INFO_CHG_LOG",
                    "access_type": "ALL",
                    "possible_keys": [
                      "IDX_USR_INFO_CHG_LOG_LOC_NM"
                    ],
                    "rows_examined_per_scan": 40,
                    "rows_produced_per_join": 27,
                    "filtered": "67.50",
                    "cost_info": {
                      "read_cost": "1.55",
                      "eval_cost": "2.70",
                      "prefix_cost": "4.25",
                      "data_read_per_join": "13K"
                    },
                    "used_columns": [
                      "LOG_TKTM",
                      "LOG_ID",
                      "USR_NO",
                      "LOC_NM"
                    ],
                    "attached_condition": "((`KAKAOBANK`.`USR_INFO_CHG_LOG`.`LOC_NM` is not null) and (`KAKAOBANK`.`USR_INFO_CHG_LOG`.`LOC_NM` <> ''))"
                  }
                }
              }
            }
          }
        },
        {
          "table": {
            "table_name": "a",
            "access_type": "ref",
            "possible_keys": [
              "<auto_key0>"
            ],
            "key": "<auto_key0>",
            "used_key_parts": [
              "usr_no",
              "rn"
            ],
            "key_length": "51",
            "ref": [
              "a.usr_no",
              "const"
            ],
            "rows_examined_per_scan": 10,
            "rows_produced_per_join": 1093,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "273.29",
              "eval_cost": "109.32",
              "prefix_cost": "427.41",
              "data_read_per_join": "341K"
            },
            "used_columns": [
              "usr_no",
              "LOG_TKTM",
              "menu_nm",
              "rn"
            ],
            "materialized_from_subquery": {
              "using_temporary_table": true,
              "dependent": false,
              "cacheable": true,
              "query_block": {
                "select_id": 5,
                "cost_info": {
                  "query_cost": "481.15"
                },
                "windowing": {
                  "windows": [
                    {
                      "name": "<unnamed window>",
                      "using_filesort": true,
                      "filesort_key": [
                        "`USR_NO`",
                        "`LOG_TKTM` desc"
                      ],
                      "functions": [
                        "row_number"
                      ]
                    }
                  ],
                  "cost_info": {
                    "sort_cost": "415.00"
                  },
                  "table": {
                    "table_name": "a",
                    "access_type": "ALL",
                    "possible_keys": [
                      "IDX_MENU_LOG_MENU_NAME"
                    ],
                    "rows_examined_per_scan": 649,
                    "rows_produced_per_join": 415,
                    "filtered": "63.94",
                    "cost_info": {
                      "read_cost": "24.65",
                      "eval_cost": "41.50",
                      "prefix_cost": "66.15",
                      "data_read_per_join": "155K"
                    },
                    "used_columns": [
                      "LOG_TKTM",
                      "LOG_ID",
                      "USR_NO",
                      "MENU_NM"
                    ],
                    "attached_condition": "(`KAKAOBANK`.`a`.`MENU_NM` not in ('login','logout'))"
                  }
                }
              }
            }
          }
        },
        {
          "table": {
            "table_name": "d",
            "access_type": "ref",
            "possible_keys": [
              "<auto_key0>"
            ],
            "key": "<auto_key0>",
            "used_key_parts": [
              "usr_no",
              "rnk"
            ],
            "key_length": "51",
            "ref": [
              "a.usr_no",
              "const"
            ],
            "rows_examined_per_scan": 10,
            "rows_produced_per_join": 11065,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "2766.26",
              "eval_cost": "1106.50",
              "prefix_cost": "4300.17",
              "data_read_per_join": "2M"
            },
            "used_columns": [
              "usr_no",
              "menu_nm",
              "cnt",
              "rnk"
            ],
            "materialized_from_subquery": {
              "using_temporary_table": true,
              "dependent": false,
              "cacheable": true,
              "query_block": {
                "select_id": 6,
                "cost_info": {
                  "query_cost": "464.19"
                },
                "windowing": {
                  "windows": [
                    {
                      "name": "<unnamed window>",
                      "using_filesort": true,
                      "filesort_key": [
                        "`usr_no`",
                        "`cnt` desc"
                      ],
                      "functions": [
                        "row_number"
                      ]
                    }
                  ],
                  "cost_info": {
                    "sort_cost": "415.00"
                  },
                  "table": {
                    "table_name": "a",
                    "access_type": "ALL",
                    "rows_examined_per_scan": 415,
                    "rows_produced_per_join": 415,
                    "filtered": "100.00",
                    "cost_info": {
                      "read_cost": "7.69",
                      "eval_cost": "41.50",
                      "prefix_cost": "49.19",
                      "data_read_per_join": "103K"
                    },
                    "used_columns": [
                      "usr_no",
                      "menu_nm",
                      "cnt"
                    ],
                    "materialized_from_subquery": {
                      "using_temporary_table": true,
                      "dependent": false,
                      "cacheable": true,
                      "query_block": {
                        "select_id": 7,
                        "cost_info": {
                          "query_cost": "66.15"
                        },
                        "grouping_operation": {
                          "using_temporary_table": true,
                          "using_filesort": false,
                          "table": {
                            "table_name": "a",
                            "access_type": "ALL",
                            "possible_keys": [
                              "IDX_MENU_LOG_MENU_NAME"
                            ],
                            "rows_examined_per_scan": 649,
                            "rows_produced_per_join": 415,
                            "filtered": "63.94",
                            "cost_info": {
                              "read_cost": "24.65",
                              "eval_cost": "41.50",
                              "prefix_cost": "66.15",
                              "data_read_per_join": "155K"
                            },
                            "used_columns": [
                              "LOG_TKTM",
                              "LOG_ID",
                              "USR_NO",
                              "MENU_NM"
                            ],
                            "attached_condition": "(`KAKAOBANK`.`a`.`MENU_NM` not in ('login','logout'))"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      ]
    }
  }
}
*/



/*
결과
사용자 번호, 성별, 나이, loc_nm, before_loc_nm, mcco_nm, 가입일, 최빈메뉴, 최근메뉴
'001','여','17','포천','연천','LG','20190301','추천','카드이용내역'
'004','남','58','양주','서울',NULL,'20190302','가이드','세이프박스'
'003','여','45','천안','용인','KT','20190305','이체내역','이체내역'
'002','남','30','창원','김해','알뜰폰','20190311','정기예금','추천'


*/

