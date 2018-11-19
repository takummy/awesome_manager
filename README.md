# README

# モデル図

- Userモデル
  - id: PK
  - name: string
  - email: string
  - password_digest: string
  - admin: boolean

- Taskモデル
  - id: PK
  - user_id: FK
  - title: string
  - content: text
  - expired_at: integer
  - priority: integer
  - state: integer

- 中間モデル
  - id: PK
  - task_id: FK
  - label_id: FK

- Labelモデル
  - id: PK
  - name: string