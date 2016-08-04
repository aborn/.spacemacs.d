(defun aborn/timer-task-each-8hour (task)
  "run `task' each 8 hour"
  (run-with-timer 300 (* 8 60 60) task))

(defun aborn/timer-task-each-hour (task)
  "run `task' each 1 hour"
  (run-with-timer 3 (* 1 60 60) task))

(defun aborn/timer-task-each-minute (task)
  "run `task' each 1 minute"
  (run-with-timer 3 (* 1 60) task))

(defun aborn/timer-task-delay-excute-once (sec task)
  "delay second exectue."
  (run-with-timer sec nil task))

(provide 'aborn-timer-task)
