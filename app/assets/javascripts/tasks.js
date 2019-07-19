window.addEventListener("load", Pagy.init);

window.addEventListener("load", function(){
    document.querySelectorAll('.task-checkbox').forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            let td = checkbox.parentNode;
            let task_link = td.getElementsByTagName("a")[0];
            let task_id = checkbox.id.split("-")[2];

            // リンクのクラスからタスクの状態を抜き出す
            let task_status = null;
            let task_class_list = task_link.classList;
            if (task_class_list.contains("task-is-created")) {
                task_status = "created";
            } else if (task_class_list.contains("task-is-started")) {
                task_status = "started";
            } else if (task_class_list.contains("task-is-finished")) {
                task_status = "finished"
            }
            // console.log(task_status);

            // PUTでの送り先URLを組み立てておく
            let toggle_status_task_path = "/tasks/" + task_id + "/toggle_status";

            Rails.ajax({
                url: toggle_status_task_path,
                type: "PUT",
                data: `status=${task_status}`,
                success: function(response) {
                    // console.log(response);
                    if(checkbox.checked) {
                        // チェックが付いた = 今、未完了から完了に変化した
                        task_link.classList.remove("task-is-created");
                        task_link.classList.remove("task-is-started");
                        task_link.classList.add("task-is-finished");
                    } else {
                        // チェックが外れた = 今、完了から未完了に変化した
                        task_link.classList.remove("task-is-started");
                        task_link.classList.remove("task-is-finished");
                        task_link.classList.add("task-is-created");
                    }
                },
                error: function(response) {
                    // エラー時にはチェックを元の状態に戻す
                    if(checkbox.checked) {
                        checkbox.checked = false;
                    } else {
                        checkbox.checked = true;
                    }
                }
            });
        }, false);
    });
}, false);
