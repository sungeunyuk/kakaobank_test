

/*
문제 2. 전체 메뉴를 대상으로 각 메뉴별 접근 현황을 확인하려고 한다.
*/

use KAKAOBANK;

SHOW TABLE STATUS LIKE 'KAKAOBANK.MENU_LOG';

SHOW INDEX FROM KAKAOBANK.MENU_LOG;

-- // 파티션을 사용하지 않는 일반 테이블의 통계 정보 수집
ANALYZE TABLE KAKAOBANK.MENU_LOG;

CREATE INDEX IDX_MENU_LOG_MENU_NAME ON KAKAOBANK.MENU_LOG (MENU_NM);

-- PRIMARY KEY (LOG_TKTM, LOG_ID)

-- EXPLAIN FORMAT=JSON


-- EXPLAIN FORMAT=JSON
select  b.menu_nm as '메뉴명',
		b.before_menu as '이전 메뉴명',
        b.cnt as '접근 건수',
        truncate( (b.cnt / a.acc_cnt) * 100 , 2) as '비율(%)'
from (
	select  MENU_NM , count(*) acc_cnt
	from KAKAOBANK.MENU_LOG
	group by MENU_NM
) a
join
(
	select MENU_NM ,
		   before_menu ,
		   count(*) cnt
	from (
		select a.* , lag(MENU_NM) over (partition by usr_no order by log_tktm) before_menu
		from KAKAOBANK.MENU_LOG a
		order by usr_no , log_tktm
	) a
	group by 1,2
) b
on a.MENU_NM = b.menu_nm
where b.before_menu is not null
order by b.menu_nm asc , b.cnt desc , b.before_menu asc
;



--- 쿼리 수정
-- menu_log 테이블 2번 read 하지 않고 처리

select menu_nm as '메뉴명' ,
	   before_menu as '이전메뉴명' ,
       cnt as '접근건수' ,
       cnt_total as '비율(%)'
from (
	select menu_nm ,
		   before_menu ,
		   cnt ,
		   truncate( (cnt / sum(cnt) over (partition by menu_nm )  ) * 100 ,2)   as cnt_total
           -- 타겟 메뉴별 컨수 합 계 비율 구하기.
	from (
			select MENU_NM ,
				   before_menu  ,
				   count(*) cnt
			from (
				select a.* ,
                       lag(MENU_NM) over (partition by usr_no order by log_tktm) before_menu
                       -- 이용자 기준으로 이전 메뉴 트레킹
				from KAKAOBANK.MENU_LOG a
				) a
			group by 1,2
		   ) a
	) a
where before_menu is not null -- 이전 메뉴명이 없을 경우 최종 아웃풋 에서 제외.
order by menu_nm asc , cnt desc , before_menu asc
;















/*
실행계획
id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1','PRIMARY','<derived3>',NULL,'ALL',NULL,NULL,NULL,NULL,'649','90.00','Using where; Using filesort'
'1','PRIMARY','<derived2>',NULL,'ref','<auto_key0>','<auto_key0>','203','b.MENU_NM','10','100.00',NULL
'3','DERIVED','<derived4>',NULL,'ALL',NULL,NULL,NULL,NULL,'649','100.00','Using temporary'
'4','DERIVED','a',NULL,'ALL',NULL,NULL,NULL,NULL,'649','100.00','Using filesort'
'2','DERIVED','MENU_LOG',NULL,'index','IDX_MENU_LOG_MENU_NAME','IDX_MENU_LOG_MENU_NAME','203',NULL,'649','100.00','Using index'

{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "8071.75"
    },
    "ordering_operation": {
      "using_filesort": true,
      "cost_info": {
        "sort_cost": "5923.14"
      },
      "nested_loop": [
        {
          "table": {
            "table_name": "b",
            "access_type": "ALL",
            "rows_examined_per_scan": 649,
            "rows_produced_per_join": 584,
            "filtered": "90.00",
            "cost_info": {
              "read_cost": "17.10",
              "eval_cost": "58.41",
              "prefix_cost": "75.51",
              "data_read_per_join": "237K"
            },
            "used_columns": [
              "MENU_NM",
              "before_menu",
              "cnt"
            ],
            "attached_condition": "((`b`.`before_menu` is not null) and (`b`.`MENU_NM` is not null))",
            "materialized_from_subquery": {
              "using_temporary_table": true,
              "dependent": false,
              "cacheable": true,
              "query_block": {
                "select_id": 3,
                "cost_info": {
                  "query_cost": "75.51"
                },
                "grouping_operation": {
                  "using_temporary_table": true,
                  "using_filesort": false,
                  "table": {
                    "table_name": "a",
                    "access_type": "ALL",
                    "rows_examined_per_scan": 649,
                    "rows_produced_per_join": 649,
                    "filtered": "100.00",
                    "cost_info": {
                      "read_cost": "10.61",
                      "eval_cost": "64.90",
                      "prefix_cost": "75.51",
                      "data_read_per_join": "375K"
                    },
                    "used_columns": [
                      "LOG_TKTM",
                      "LOG_ID",
                      "USR_NO",
                      "MENU_NM",
                      "before_menu"
                    ],
                    "materialized_from_subquery": {
                      "using_temporary_table": true,
                      "dependent": false,
                      "cacheable": true,
                      "query_block": {
                        "select_id": 4,
                        "cost_info": {
                          "query_cost": "1364.15"
                        },
                        "ordering_operation": {
                          "using_filesort": true,
                          "cost_info": {
                            "sort_cost": "649.00"
                          },
                          "windowing": {
                            "windows": [
                              {
                                "name": "<unnamed window>",
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
                              }
                            ],
                            "cost_info": {
                              "sort_cost": "649.00"
                            },
                            "table": {
                              "table_name": "a",
                              "access_type": "ALL",
                              "rows_examined_per_scan": 649,
                              "rows_produced_per_join": 649,
                              "filtered": "100.00",
                              "cost_info": {
                                "read_cost": "1.25",
                                "eval_cost": "64.90",
                                "prefix_cost": "66.15",
                                "data_read_per_join": "243K"
                              },
                              "used_columns": [
                                "LOG_TKTM",
                                "LOG_ID",
                                "USR_NO",
                                "MENU_NM"
                              ]
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
              "MENU_NM"
            ],
            "key_length": "203",
            "ref": [
              "b.MENU_NM"
            ],
            "rows_examined_per_scan": 10,
            "rows_produced_per_join": 5923,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "1480.78",
              "eval_cost": "592.31",
              "prefix_cost": "2148.61",
              "data_read_per_join": "1M"
            },
            "used_columns": [
              "MENU_NM",
              "acc_cnt"
            ],
            "materialized_from_subquery": {
              "using_temporary_table": true,
              "dependent": false,
              "cacheable": true,
              "query_block": {
                "select_id": 2,
                "cost_info": {
                  "query_cost": "66.15"
                },
                "grouping_operation": {
                  "using_filesort": false,
                  "table": {
                    "table_name": "MENU_LOG",
                    "access_type": "index",
                    "possible_keys": [
                      "IDX_MENU_LOG_MENU_NAME"
                    ],
                    "key": "IDX_MENU_LOG_MENU_NAME",
                    "used_key_parts": [
                      "MENU_NM"
                    ],
                    "key_length": "203",
                    "rows_examined_per_scan": 649,
                    "rows_produced_per_join": 649,
                    "filtered": "100.00",
                    "using_index": true,
                    "cost_info": {
                      "read_cost": "1.25",
                      "eval_cost": "64.90",
                      "prefix_cost": "66.15",
                      "data_read_per_join": "243K"
                    },
                    "used_columns": [
                      "LOG_TKTM",
                      "LOG_ID",
                      "MENU_NM"
                    ]
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
메뉴명, 이전 메뉴명, 접근 건수, 비율(%)
'login','logout','113','95.76'
'logout','가이드','16','13.55'
'logout','이체내역','15','12.71'
'logout','추천','15','12.71'
'logout','내정보','14','11.86'
'logout','모임통장','13','11.01'
'logout','세이프박스','12','10.16'
'logout','내카드','11','9.32'
'logout','내신용정보','10','8.47'
'logout','정기예금','6','5.08'
'logout','카드이용내역','6','5.08'
'가이드','login','14','30.43'
'가이드','세이프박스','10','21.73'
'가이드','추천','7','15.21'
'가이드','정기예금','4','8.69'
'가이드','내정보','3','6.52'
'가이드','내카드','2','4.34'
'가이드','모임통장','2','4.34'
'가이드','카드이용내역','2','4.34'
'가이드','내신용정보','1','2.17'
'가이드','이체내역','1','2.17'
'내신용정보','login','10','25.64'
'내신용정보','세이프박스','5','12.82'
'내신용정보','내카드','4','10.25'
'내신용정보','모임통장','4','10.25'
'내신용정보','추천','4','10.25'
'내신용정보','가이드','3','7.69'
'내신용정보','내정보','3','7.69'
'내신용정보','이체내역','3','7.69'
'내신용정보','정기예금','3','7.69'
'내정보','세이프박스','7','21.87'
'내정보','login','5','15.62'
'내정보','추천','5','15.62'
'내정보','카드이용내역','4','12.50'
'내정보','이체내역','3','9.37'
'내정보','내신용정보','2','6.25'
'내정보','내카드','2','6.25'
'내정보','모임통장','2','6.25'
'내정보','정기예금','2','6.25'
'내카드','login','13','31.70'
'내카드','이체내역','7','17.07'
'내카드','정기예금','7','17.07'
'내카드','가이드','4','9.75'
'내카드','세이프박스','4','9.75'
'내카드','내신용정보','2','4.87'
'내카드','모임통장','2','4.87'
'내카드','내정보','1','2.43'
'내카드','카드이용내역','1','2.43'
'모임통장','세이프박스','6','16.21'
'모임통장','이체내역','5','13.51'
'모임통장','정기예금','5','13.51'
'모임통장','login','4','10.81'
'모임통장','카드이용내역','4','10.81'
'모임통장','가이드','3','8.10'
'모임통장','내카드','3','8.10'
'모임통장','추천','3','8.10'
'모임통장','내신용정보','2','5.40'
'모임통장','내정보','2','5.40'
'세이프박스','login','14','26.92'
'세이프박스','내카드','8','15.38'
'세이프박스','내신용정보','6','11.53'
'세이프박스','이체내역','6','11.53'
'세이프박스','카드이용내역','6','11.53'
'세이프박스','가이드','4','7.69'
'세이프박스','모임통장','3','5.76'
'세이프박스','내정보','2','3.84'
'세이프박스','정기예금','2','3.84'
'세이프박스','추천','1','1.92'
'이체내역','login','16','32.00'
'이체내역','내신용정보','10','20.00'
'이체내역','추천','5','10.00'
'이체내역','가이드','4','8.00'
'이체내역','내카드','4','8.00'
'이체내역','내정보','3','6.00'
'이체내역','카드이용내역','3','6.00'
'이체내역','세이프박스','2','4.00'
'이체내역','정기예금','2','4.00'
'이체내역','모임통장','1','2.00'
'정기예금','login','13','35.13'
'정기예금','가이드','7','18.91'
'정기예금','추천','7','18.91'
'정기예금','내신용정보','3','8.10'
'정기예금','내카드','3','8.10'
'정기예금','이체내역','2','5.40'
'정기예금','내정보','1','2.70'
'정기예금','모임통장','1','2.70'
'추천','login','24','48.00'
'추천','세이프박스','5','10.00'
'추천','내카드','4','8.00'
'추천','가이드','3','6.00'
'추천','모임통장','3','6.00'
'추천','이체내역','3','6.00'
'추천','카드이용내역','3','6.00'
'추천','내신용정보','2','4.00'
'추천','정기예금','2','4.00'
'추천','내정보','1','2.00'
'카드이용내역','모임통장','6','20.68'
'카드이용내역','login','5','17.24'
'카드이용내역','이체내역','5','17.24'
'카드이용내역','정기예금','4','13.79'
'카드이용내역','추천','3','10.34'
'카드이용내역','가이드','2','6.89'
'카드이용내역','내정보','2','6.89'
'카드이용내역','내신용정보','1','3.44'
'카드이용내역','세이프박스','1','3.44'

*/