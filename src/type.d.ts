type Credentials = {
  email: string | null
  password: string | null
}

type LoginResponse = {
  token: string
  user: User
}

type User = {
  email: string
  id: number
  is_blocked?: boolean
  name: string
  permissions: Permission[] | null
  roles: Role[] | null
}
