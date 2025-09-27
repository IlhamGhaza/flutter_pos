# API Documentation

## Endpoint: Discounts (`/api/discounts`)

### Create Discount

**Method:** POST
**URL:** `/api/discounts`
**Status Code:** 201 Created

**Request Body:**

```json
{
  "name": "Holiday Sale",
  "description": "Special holiday discount",
  "type": "percentage",
  "value": 15,
  "min_quantity": 1,
  "max_quantity": 10,
  "min_amount": 50.00,
  "apply_to": "all",
  "customer_type": "all",
  "combinable": false,
  "status": "active",
  "start_date": "2025-07-15",
  "expired_date": "2025-07-31",
  "start_time": "09:00:00",
  "end_time": "17:00:00",
  "valid_days": [1, 2, 3, 4, 5]
}
```

**Keterangan:**

* `valid_days` adalah array berisi angka yang merepresentasikan hari dalam minggu.
* Hari ke-1 = Senin (Monday), ke-2 = Selasa (Tuesday), ke-3 = Rabu (Wednesday), ke-4 = Kamis (Thursday), ke-5 = Jumat (Friday), ke-6 = Sabtu (Saturday), ke-7 = Minggu (Sunday).

**Response:**

```json
{
  "status": "success",
  "message": "Discount created successfully",
  "data": {
    "id": 6,
    "name": "Holiday Sale",
    "description": "Special holiday discount",
    "type": "percentage",
    "value": "15.00",
    "min_quantity": 1,
    "max_quantity": 10,
    "min_amount": "50.00",
    "apply_to": "all",
    "customer_type": "all",
    "combinable": false,
    "status": "inactive",
    "start_date": "2025-06-30T17:00:00.000000Z",
    "expired_date": "2025-07-30T17:00:00.000000Z",
    "start_time": "09:00:00",
    "end_time": "17:00:00",
    "usage_count": 0,
    "created_at": "2025-06-22T00:22:59.000000Z",
    "updated_at": "2025-06-22T00:22:59.000000Z",
    "valid_days": [
      {
        "id": 14,
        "discount_id": 6,
        "day_of_week": 1,
        "created_at": "2025-06-22T00:22:59.000000Z",
        "updated_at": "2025-06-22T00:22:59.000000Z",
        "deleted_at": null
      },
      {
        "id": 15,
        "discount_id": 6,
        "day_of_week": 2,
        "created_at": "2025-06-22T00:22:59.000000Z",
        "updated_at": "2025-06-22T00:22:59.000000Z",
        "deleted_at": null
      },
      {
        "id": 16,
        "discount_id": 6,
        "day_of_week": 3,
        "created_at": "2025-06-22T00:22:59.000000Z",
        "updated_at": "2025-06-22T00:22:59.000000Z",
        "deleted_at": null
      },
      {
        "id": 17,
        "discount_id": 6,
        "day_of_week": 4,
        "created_at": "2025-06-22T00:22:59.000000Z",
        "updated_at": "2025-06-22T00:22:59.000000Z",
        "deleted_at": null
      },
      {
        "id": 18,
        "discount_id": 6,
        "day_of_week": 5,
        "created_at": "2025-06-22T00:22:59.000000Z",
        "updated_at": "2025-06-22T00:22:59.000000Z",
        "deleted_at": null
      }
    ]
  }
}
```

---

### Delete Discount

**Method:** DELETE
**URL:** `/api/discounts/{id}`
**Example:** `/api/discounts/6`
**Status Code:** 200 OK

**Response:**

```json
{
  "status": "success",
  "message": "Discount deleted successfully"
}
```

---

## Endpoint: Categories (`/api/categories`)

### Create Category

**Method:** POST
**URL:** `/api/categories`
**Status Code:** 201 Created

**Request Body:**

```json
{
  "name": "test"
}
```

**Response:**

```json
{
  "success": true,
  "message": "Kategori berhasil ditambahkan",
  "data": {
    "id": 8,
    "name": "test",
    "created_at": "2025-09-26T13:52:01.000000Z",
    "updated_at": "2025-09-26T13:52:01.000000Z"
  }
}
```

---

### Delete Category

**Method:** DELETE
**URL:** `/api/categories/{id}`
**Example:** `/api/categories/8`
**Status Code:** 200 OK

**Response:**

```json
{
  "status": "success",
  "message": "Discount deleted successfully"
}
```